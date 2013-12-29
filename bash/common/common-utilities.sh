#!/bin/sh

# Clears Terminal output using AppleScript.
function clearTerminal()
{
    osascript ~/Repos/Scripts/osa/clear-terminal.scpt
}

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

# The Pay Credit Card script.
function payCreditCard()
{
    acc1=$1
    acc2=$2

    account="0"
    while [ $account != "1" ] && [ $account != "2" ]; do
        read -p "`echo "\033[37m"`What account would you like to make the payment from?`echo "\033[0m"` => " -r
        if [[ $REPLY =~ ^[1]$ ]]; then
            echo
            message blue "ACC" "\033[33m$acc1\033[0m"
            account=1
        elif [[ $REPLY =~ ^[2]$ ]]; then
            echo
            message blue "Acc" "\033[33m$acc2\033[0m"
            account=2
        fi
        echo
    done

    amount="0"
    amountValid="0"
    while [ $amountValid == "0" ]; do
        read -p "`echo "\033[37m"`How much would you like to pay? [ie: 15.00]`echo "\033[0m"` => " -r
        amount=$REPLY
        if [[ "$amount" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            amount="`printf "%0.2f\n" $amount`"
            echo
            message blue "PAY" "\033[33m£$amount\033[0m"
            amountValid="1"
        fi
        echo
    done

    actionConfirmed="0"
    while [ $actionConfirmed == "0" ]; do
        read -p "`echo "\033[37m"`You are about to make a payment of `echo "\033[33m£$amount\033[0m"`. Once started, the process cannot be aborted.`echo "\033[0m\n\n\033[42m Confirm \033[40m\033[32m"` Are you absolutely sure you want to continue? `echo "\033[37m"`[y/n]`echo "\033[0m"` `echo "\033[0m"` => " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            actionConfirmed="1"
        else
            read -p "`echo "\033[37m"`Abort? [y/n]`echo "\033[0m"` => " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "\n"
                actionConfirmed="1"
                exit
            else
                echo "\n"
            fi
        fi
    done
}