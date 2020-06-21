#!/bin/bash

VERSION="0.1-beta"

C_GREEN=`tput setaf 2`
C_YELLOW=`tput setaf 3`
C_RED=`tput setaf 1`
C_END=`tput sgr0`

read_char() {
    stty -icanon -echo
    eval "$1=\$(dd bs=1 count=1 2>/dev/null)"
    stty icanon echo
}

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

print_help() {
    cat << EOF
Usage: adbss [-o <output_dir>][-h][-v]

-o Output directory for the screenshots
-h Show help
-v Show version
EOF
}

print_version() {
    echo $VERSION
}

echo -e "${C_GREEN}adbss (Android Debug Bridge ScreenShoter)${C_END}"

OUTPUT_DIR="$HOME/adbss-outputs"

while getopts ":o:hv" opt; do
    case $opt in
        h)
            print_help
            exit 0
            ;;
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        v)
            print_version
            exit 0
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

if mkdir -p $OUTPUT_DIR
then
    OUTPUT_DIR=$(cd ${OUTPUT_DIR} && pwd)
    echo "Output directory: ${OUTPUT_DIR}"
else
    echo -e "${C_RED}Unable to create specified output directory.${C_END}"
    exit 1
fi

echo -e "${C_YELLOW}Press any key to take a screenshot, 'q' to quit.${C_END}"

while true
do
    read_char INPUT
    if [[ $INPUT == 'q' ]]
    then
        echo -e "${C_GREEN}Closing adbss. Your files are" \
                "saved at: ${OUTPUT_DIR}.${C_END}";
        exit 0
    else
        take_screenshot
    fi
done
