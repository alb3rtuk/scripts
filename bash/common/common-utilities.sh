#!/bin/sh

# Detects displays and returns either 'single' or 'multiple' in a global variable named: displays
function detectDisplays()
{
    local SINGLEOUTPUT="Graphics/Displays: Intel Iris: Chipset Model: Intel Iris Type: GPU Bus: Built-In VRAM (Total): 1024 MB Vendor: Intel (0x8086) Device ID: 0x0a2e Revision ID: 0x0009 Displays: Color LCD: Display Type: Retina LCD Resolution: 2560 x 1600 Retina: Yes Pixel Depth: 32-Bit Color (ARGB8888) Main Display: Yes Mirror: Off Online: Yes Built-In: Yes"
    local MULTIPLEOUTPUTHOME="Graphics/Displays: Intel Iris: Chipset Model: Intel Iris Type: GPU Bus: Built-In VRAM (Total): 1024 MB Vendor: Intel (0x8086) Device ID: 0x0a2e Revision ID: 0x0009 Displays: Color LCD: Display Type: Retina LCD Resolution: 2560 x 1600 Retina: Yes Pixel Depth: 32-Bit Color (ARGB8888) Main Display: Yes Mirror: Off Online: Yes Built-In: Yes S24C750: Resolution: 1920 x 1080 @ 60Hz (1080p) Pixel Depth: 32-Bit Color (ARGB8888) Mirror: Off Online: Yes Rotation: Supported Television: Yes S24B300: Resolution: 1920 x 1080 @ 60Hz (1080p) Pixel Depth: 32-Bit Color (ARGB8888) Mirror: Off Online: Yes Rotation: Supported Television: Yes"
    local MULTIPLEOUTPUTBRIGHTPEARL="Graphics/Displays: Intel Iris: Chipset Model: Intel Iris Type: GPU Bus: Built-In VRAM (Total): 1024 MB Vendor: Intel (0x8086) Device ID: 0x0a2e Revision ID: 0x0009 Displays: Color LCD: Display Type: Retina LCD Resolution: 2560 x 1600 Retina: Yes Pixel Depth: 32-Bit Color (ARGB8888) Main Display: Yes Mirror: Off Online: Yes Built-In: Yes P246H: Resolution: 1920 x 1080 @ 60 Hz Pixel Depth: 32-Bit Color (ARGB8888) Display Serial Number: LQK0D0208511 Mirror: Off Online: Yes Rotation: Supported P246H: Resolution: 1920 x 1080 @ 60 Hz Pixel Depth: 32-Bit Color (ARGB8888) Display Serial Number: LQK0D0208511 Mirror: Off Online: Yes Rotation: Supported"
    local OUTPUT=$(system_profiler SPDisplaysDataType ARG1 2>&1)
    if grep -q "$MULTIPLEOUTPUTHOME" <<<$OUTPUT; then
        displays="multiple"
    elif grep -q "$MULTIPLEOUTPUTBRIGHTPEARL" <<<$OUTPUT; then
        displays="multiple"
    elif grep -q "$SINGLEOUTPUT" <<<$OUTPUT; then
        displays="single"
    else
        displays="single"
    fi
}

# Displays a message with the first set of words colored
function message()
{
    color=$1
    title=$2
    message=$3
    if [ "$color" == "black" ]; then
        colorDigit="0"
    elif [ "$color" == "red" ]; then
        colorDigit="1"
    elif [ "$color" == "green" ]; then
        colorDigit="2"
    elif [ "$color" == "yellow" ]; then
        colorDigit="3"
    elif [ "$color" == "blue" ]; then
        colorDigit="4"
    elif [ "$color" == "magenta" ]; then
        colorDigit="5"
    elif [ "$color" == "cyan" ]; then
        colorDigit="6"
    elif [ "$color" == "white" ]; then
        colorDigit="7"
    else
        error "The color '$color' isn't defined."
    fi
    echo "`tput setab "$colorDigit"` $title `tput setab 0` $message\033[0m"
}

# Displays error message and dies.
function error()
{
    message=$1
    echo "`tput setab 1` ERROR `tput setab 0` $message"
    exit
}

# Checks if a file exists. Exits script if it doesn't.
function verifyFileExists()
{
    file=$1
    if [ ! -f $file ]; then
        echo "`tput setab 1` ERROR: `tput setab 0` The file `tput setaf 3`$file`tput setaf 7` doesn't exist."
        exit
    fi
}

# Logs an entry in the file: ~Repos/Scripts/backup/cronlog.txt
# Used for logging when a cron was kicked off.
function logCron()
{
    logfile=/Users/Albert/Repos/Scripts/backup/cronlog.txt
    # echo "$(date) - $1" | cat - $logfile > /tmp/out && mv /tmp/out $logfile
    echo "$(date) - $1" >> $logfile
}