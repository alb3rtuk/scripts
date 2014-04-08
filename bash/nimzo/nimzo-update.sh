#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

dirToScan="/Users/Albert/Repos/Nimzo/httpdocs/public/dev"
jsDir="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/js"
cssDir="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/css"

hash=$(date +"%m%d%y%k%M%S")

if [[ ! -d ${jsDir} ]]; then
    cd /Users/Albert/Repos/Nimzo/httpdocs/public/min/lib
    mkdir -p js
fi
if [[ ! -d ${cssDir} ]]; then
    cd /Users/Albert/Repos/Nimzo/httpdocs/public/min/lib
    mkdir -p css
fi

jsFile=0
for file in $(find ${jsDir} -type f -name '*.js'); do
    jsFile=${file}
done

# Compress Javascript
for file in $(find ${dirToScan} -type f -name '*.js'); do
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
        if [[ -f ${minFile} ]]; then
            minFileLMT=$(stat -f "%m %N" ${minFile} | cut -f 1 -d" ")
        else
            minFileLMT=0
        fi

        # If the DEV file LMT (last modified time) is greater than the MIN file LMT, run compression
        if [[ ${devFileLMT} > ${minFileLMT} ]] || [ ! -f ${minFile} ] || [[ ${jsFile} == 0 ]]; then

            if [[ ! -f ${minFile} ]]; then
                mkdir -p ${minFile%/*}
                touch ${minFile}
            fi

            # Compress/minimize the file
            java -jar /Users/Albert/Bin/exec/yuicompressor-2.4.8.jar ${file} -o ${minFile} --charset utf-8

            # Output filename to terminal
            find="/Users/Albert/Repos/Nimzo/httpdocs/"
            replace=""
            fileDisplay=${file//${find}/${replace}}
            echo "Compressing: ${fileDisplay}"

            # Add the (possibly new) file to GIT
            cd ~/Repos/Nimzo/
            git add ${minFile}

            # If the file which was comrpressed is within the /js-app directoy, re-create the merged .js file.
            if [[ `dirname ${file}` == "/Users/Albert/Repos/Nimzo/httpdocs/public/dev/lib/js-app" ]]  || [[ ${jsFile} == 0 ]]; then

                jsFile=1

                cd ~/Repos/Nimzo

                # Delete the current merged .js file.
                for file in $(find ${jsDir} -type f -name '*.js'); do
                    rm -rf ${file}
                    git rm ${file}
                done

                # Re-create the merged .js file.
                minJsFile="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/js/app.min.${hash}.js"
                if [[ ! -f ${minJsFile} ]]; then
                    mkdir -p ${minJsFile%/*}
                    touch ${minJsFile}
                fi

                # Merge the contents of all the files in /js-app into a single file.
                cd ~/Repos/Nimzo/httpdocs/public/min/lib/js-app
                cat *.js > ${minJsFile}

                echo "Recompiled: ${minJsFile}"

                # Add it to GIT.
                cd ~/Repos/Nimzo/
                git add ${minJsFile}
            fi
        fi
    fi
done

# Compile Less
minCssLMT=0
for file in $(find ${cssDir} -type f -name 'app.min.*.css'); do
    minCssLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")
done

for file in $(find ${dirToScan} -type f -name '*.less'); do
    if [[ -s ${file} ]]; then

        # Get the last modified since epoch timestamps of .less file.
        devCssLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")

        # If even ONE .less files is newer than the global minizmed CSS (app.min.css), re-compile the lot & exit loop
        if [[ ${devCssLMT} > ${minCssLMT} ]]; then

            cd ~/Repos/Nimzo

            # Delete the current compiled .css file.
            if [[ -d ${cssDir} ]]; then
                for file in $(find ${cssDir} -type f -name '*.css'); do
                    rm -rf ${file}
                    git rm ${file}
                done
            fi

            # Re-create the compiled .css file.
            minCssFile="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/css/app.min.${hash}.css"
            if [[ ! -f ${minCssFile} ]]; then
                mkdir -p ${minCssFile%/*}
                touch ${minCssFile}
            fi

            # Compile to Less into CSS
            cd ~/Repos/Nimzo/httpdocs
            lessc public/dev/lib/less/app.less > ${minCssFile} -x -s

            echo "Recompiled: ${minCssFile}"

            # Add it to GIT.
            cd ~/Repos/Nimzo/
            git add ${minCssFile}

            # Break out of script, we only need to do this once.
            break
        fi
    fi
done