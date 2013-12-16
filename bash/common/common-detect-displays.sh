#!/bin/sh

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
detectDisplays