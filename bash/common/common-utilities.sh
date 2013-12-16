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
    echo "`tput setab 4` DETECT DISPLAYS `tput setab 0` Detected $displays display(s)."
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