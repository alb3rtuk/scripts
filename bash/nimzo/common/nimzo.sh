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
if [[ ${type} != "lib" ]] && [[ ${type} != "script" ]] && [[ ${type} != "sleek" ]] && [[ ${type} != "page" ]] && [[ ${type} != "modal" ]] && [[ ${type} != "overlay" ]] && [[ ${type} != "system" ]] && [[ ${type} != "widget" ]] && [[ ${type} != "pagehelper" ]] && [[ ${type} != "modalhelper" ]] && [[ ${type} != "overlayhelper" ]] && [[ ${type} != "systemhelper" ]] && [[ ${type} != "widgethelper" ]]; then
    echo
    message red "ERROR" "You must specify what you want to create. Valid parameters are:"
    echo
    echo "        \033[36mlib\033[0m"
    echo "        \033[36mscript\033[0m"
    echo "        \033[36msleek\033[0m"
    echo "        \033[33mmodal\033[0m"
    echo "        \033[33mmodalhelper\033[0m"
    echo "        \033[33moverlay\033[0m"
    echo "        \033[33moverlayhelper\033[0m"
    echo "        \033[33mpage\033[0m"
    echo "        \033[33mpagehelper\033[0m"
    echo "        \033[33msystem\033[0m"
    echo "        \033[33msystemhelper\033[0m"
    echo "        \033[33mwidget\033d[0m"
    echo "        \033[33mwidgethelper\033d[0m"
    echo
    exit
fi

# Check that route exists.
if [[ ${type} == "lib" ]] || [[ ${type} == "script" ]]; then
    if [[ ${route} == "" ]]; then
        echo
        message red "ERROR" "You must specify a \033[35m'folder/classname'\033[0m. Valid parameters are:"
        echo
        echo "        \033[33mcore/SomeClass\033[0m"
        echo "        \033[33mcore/SomeClass.php\033[0m"
        echo
        exit
    fi
elif [[ ${type} == "sleek" ]]; then
    if [[ ${route} == "" ]]; then
        echo
        message red "ERROR" "You must specify a \033[35m'folder/classname'\033[0m [ to be placed inside \033[33mprivate/lib/sleek/library\033[0m ]. Valid parameters are:"
        echo
        echo "        \033[33mcommon/SleekSomeClass\033[0m"
        echo "        \033[33mcommin/SleekSomeClass.php\033[0m"
        echo
        exit
    fi
else
    # Valid route (different for controllers)
    if [[ ${route} == "" ]]; then
        echo
        message red "ERROR" "You must specify a \033[35m'route'\033[0m. Valid parameters are:"
        echo
        echo "        \033[33mdashboard\033[0m"
        echo "        \033[33mdashboard/messages\033[0m"
        echo
        exit
    fi

    if [[ ${type} == "pagehelper" ]] || [[ ${type} == "modalhelper" ]] || [[ ${type} == "overlayhelper" ]] || [[ ${type} == "systemhelper" ]] || [[ ${type} == "widgethelper" ]]; then
        if [[ ${helper} == "" ]]; then
            echo
            message red "ERROR" "You must specify a \033[35m'route'\033[0m and a \033[35m'helper name'\033[0m (seperated by a space). Valid parameters are:"
            echo
            echo "        \033[33mdashboard SomeHelper\033[0m"
            echo "        \033[33mdashboard SomeHelper.php\033[0m"
            echo "        \033[33mdashboard/messages SomeHelper\033[0m"
            echo "        \033[33mdashboard/messages SomeHelper.php\033[0m"
            echo
            exit
        fi
    fi
fi