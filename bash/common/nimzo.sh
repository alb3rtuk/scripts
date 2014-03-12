#!/bin/sh

validateControllerName() {
    if [[ ${controllerName} == "" ]]; then
        message red "ERROR" "You must specify a name (1st parameter). Valid names are:"
        echo "\033[33mdashboard\033[0m"
        echo "\033[33mdashboard/messages\033[0m"
        exit
    fi
}