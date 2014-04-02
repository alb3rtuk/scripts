#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

dir="/Users/Albert/Repos/Nimzo/httpdocs/public/dev"

# Compress Javascript
for file in $(find ${dir} -type f -name '*.js'); do
    if [[ -s ${file} ]]; then

        # Get the filename of the minimized file
        find="httpdocs/public/dev"
        replace="httpdocs/public/min"
        minFile=${file//${find}/${replace}}
        find=".js"
        replace=".min.js"
        minFile=${minFile//${find}/${replace}}

        # Get the last modified since epoch timestamps of both the dev + min files.
        devFileLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")
        minFileLMT=$(stat -f "%m %N" ${minFile} | cut -f 1 -d" ")

        # If the DEV file LMT (last modified time) is greater than the MIN file LMT, run compression
        if [[ $devFileLMT > $minFileLMT ]]; then

            # Compress/minimize the file
            java -jar /Users/Albert/Bin/exec/yuicompressor-2.4.8.jar ${file} -o ${minFile} --charset utf-8

            # Output filename to terminal
            find="/Users/Albert/Repos/Nimzo/httpdocs/"
            replace=""
            minFileDisplay=${minFile//${find}/${replace}}
            echo "Compressing: ${minFileDisplay}"

            # Add the (possibly new) file to GIT
            cd ~/Repos/Nimzo/
            git add ${minFile}
        fi
    fi
done

# Compile Less
minCssLMT=$(stat -f "%m %N" ~/Repos/Nimzo/httpdocs/public/min/lib/css/app.min.css | cut -f 1 -d" ")
for file in $(find ${dir} -type f -name '*.less'); do
    if [[ -s ${file} ]]; then

        # Get the last modified since epoch timestamps of .less file.
        lessFileLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")

        # If even ONE .less files is newer than the global minizmed CSS (app.min.css), re-compile the lot & exit loop
        if [[ ${lessFileLMT} > ${minCssLMT} ]]; then
            echo "Re-compiling: public/min/lib/css/app.min.css"
            cd ~/Repos/Nimzo/httpdocs
            lessc public/dev/lib/less/app.less > public/min/lib/css/app.min.css -x -s
            break
        fi
    fi
done