#!/bin/bash

# Color for successful operations.
C_GREEN="\e[32m"

# Color for hints/warnings.
C_YELLOW="\e[33m"

# Color for errors.
C_RED="\e[31m"

# Ends text coloring.
C_END="\e[0m"

# Function that reads character from the command line.
read_char() {
    stty -icanon -echo
    eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
    stty icanon echo
}

# Function that takes the screenshot from the device 
# and saves it to the output directory.
take_screenshot() {
    FILENAME="abdss_$(date +"%Y_%m_%d_%H_%M_%S").png"
    TEMP_FILE="/sdcard/adbss_temp.png"

    echo -ne "Saving screenshot to ${C_YELLOW}" \
             "${OUTPUT_DIR}/${FILENAME}${C_END}..."
    adb shell screencap -p $TEMP_FILE
    adb pull $TEMP_FILE $OUTPUT_DIR/$FILENAME &> /dev/null
    adb shell rm $TEMP_FILE
    echo -e "${C_GREEN}\t[DONE]${C_END}"
}

# Function that prints the 'help page'.
print_help() {
    echo "See README.md.."
}

# Welcome message.
echo -e "${C_GREEN}Welcome to ADBSS (Android Debug Bridge Recorded)!${C_END}"

# ===== Read output directory. =====

# Default output directory.
OUTPUT_DIR="$HOME/adbss-outputs"

# Read output directory from the -o flag.
while getopts ":o:h" opt; do
    case $opt in
        h)
            print_help
            exit 0
            ;;
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        \?)
            echo -e "${C_RED}Invalid option, use -h flag to learn about the" \
                    "usage.${C_END}"
            exit 1
            ;;
        :)
            echo -e "${C_RED}Option -$OPTARG requires an argument." \
                    "Use -h flag option to learn about the usage.${C_END}"
            exit 1
            ;;
    esac
done

# Try to create an output directory.
if mkdir -p $OUTPUT_DIR
then
    OUTPUT_DIR=$(cd ${OUTPUT_DIR} && pwd)
    echo "Output directory: ${OUTPUT_DIR}"
else
    echo -e "${C_RED}Unable to create specified output directory.${C_END}"
    exit 1
fi

# ===== Start recording. =====

# Message on how to use ADBSS.
echo -e "${C_YELLOW}Press any key to take a screenshot, 'q' to quit.${C_END}"

# Listen for character input.
while true
do
    read_char INPUT
    if [[ $INPUT == 'q' ]]
    then
        echo -e "${C_GREEN}Closing ADBSS. Your files are" \
                "saved at: ${OUTPUT_DIR}.${C_END}";
        exit 0
    else
        take_screenshot
    fi
done
