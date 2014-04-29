#!/bin/sh

# Re-Compiles Less file.
# If a parameter is passed (ANY PARAMETER) it will minimize the .less, otherwise not.

min=$1

cd ~/Repos/Nimzo/httpdocs

if [[ ${min} == "" ]]; then
    lessc public/dev/lib/app-less/app.less > public/min/lib/css/app.min.css
else
    lessc public/dev/lib/app-less/app.less > public/min/lib/css/app.min.css -x
fi

