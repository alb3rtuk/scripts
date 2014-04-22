#!/bin/sh

validateControllerName() {
    if [[ ${controllerName} == "" ]]; then
        echo
        message red "ERROR" "You must specify a 'route'. Valid routes are:"
        echo
        echo "        \033[33mdashboard\033[0m"
        echo "        \033[33mdashboard/messages\033[0m"
        echo
        exit
    fi
}