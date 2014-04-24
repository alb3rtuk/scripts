#!/bin/sh

# This is the common script for the following 2 files:
#
# nimzo-create.sh
# nimzo-remove.sh
#
# NO OTHER files should include this!

cd ~/Repos/Nimzo/

# Make type lowercase.
type=`echo ${type} | tr '[:upper:]' '[:lower:]'`

# Check that type exists.
if [[ ${type} != "lib" ]] && [[ ${type} != "script" ]] && [[ ${type} != "app" ]] && [[ ${type} != "modal" ]] && [[ ${type} != "overlay" ]] && [[ ${type} != "system" ]] && [[ ${type} != "widget" ]]; then
    echo
    message red "ERROR" "You must specify what you want to create. Valid parameters are:"
    echo
    echo "        \033[36mlib\033[0m"
    echo "        \033[36mscript\033[0m"
    echo "        \033[33mapp\033[0m"
    echo "        \033[33mmodal\033[0m"
    echo "        \033[33moverlay\033[0m"
    echo "        \033[33msystem\033[0m"
    echo "        \033[33mwidget\033[0m"
    echo
    exit
fi

# Check that route exists.
if [[ ${type} == "lib" ]] || [[ ${type} == "script" ]]; then
    if [[ ${route} == "" ]]; then
        echo
        message red "ERROR" "You must specify a 'folder/classname'. Valid parameters are:"
        echo
        echo "        \033[33mcore/SomeClass\033[0m"
        echo "        \033[33mdto/SomeDto\033[0m"
        echo
        exit
    fi
else
    # Valid route (different for controllers)
    if [[ ${route} == "" ]]; then
        echo
        message red "ERROR" "You must specify a 'route'. Valid parameters are:"
        echo
        echo "        \033[33mdashboard\033[0m"
        echo "        \033[33mdashboard/messages\033[0m"
        echo
        exit
    fi
fi