#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

dirToScan="/Users/Albert/Repos/Nimzo/httpdocs/public/dev"
jsDir="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/js"
cssDir="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/css"

if [[ ! -d ${jsDir} ]]; then
    cd /Users/Albert/Repos/Nimzo/httpdocs/public/min/lib
    mkdir -p js
fi
if [[ ! -d ${cssDir} ]]; then
    cd /Users/Albert/Repos/Nimzo/httpdocs/public/min/lib
    mkdir -p css
fi

jsFile=0
for file in $(find ${jsDir} -type f -name 'app*.js'); do
    jsFile=${file}
done

# Compress Javascript
for file in $(find ${dirToScan} -type f -name '*.js'); do
    if [[ -f ${file} ]]; then

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

            # Add the (possibly new) file to GIT
            cd ~/Repos/Nimzo/
            git add ${minFile}

            if [[ -s ${file} ]]; then
                # Compress/minimize the file (but only if it contains data).
                java -jar /Users/Albert/Bin/exec/yuicompressor-2.4.8.jar ${file} -o ${minFile} --charset utf-8

                # Output filename to terminal
                find="/Users/Albert/Repos/Nimzo/httpdocs/"
                replace=""
                fileDisplay=${file//${find}/${replace}}
                echo "Compressing: ${fileDisplay}"
            else
                # Clear the file
                cat /dev/null > ${minFile}
            fi

            # If the file which was comrpressed is within the /app-js directoy, re-create the merged .js file.
            if [[ `dirname ${file}` == */Users/Albert/Repos/Nimzo/httpdocs/public/dev/lib/app-js* ]]  || [[ ${jsFile} == 0 ]]; then

                jsFile=1

                cd ~/Repos/Nimzo

                # Re-create the merged .js file. (if doesn't exist)
                minJsFile="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/js/app.min.js"
                if [[ ! -f ${minJsFile} ]]; then
                    mkdir -p ${minJsFile%/*}
                    touch ${minJsFile}
                fi

                # Merge the contents of all the files in /app-js into a single file.
                cd ~/Repos/Nimzo/httpdocs/public/min/lib/app-js
                find . -iname "*.js" -exec cat "{}" \; > ${minJsFile}

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
for file in $(find ${cssDir} -type f -name 'app*.css'); do
    minCssLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")
done

for file in $(find ${dirToScan} -type f -name '*.less'); do
    if [[ -f ${file} ]]; then

        # Get the last modified since epoch timestamps of .less file.
        devCssLMT=$(stat -f "%m %N" ${file} | cut -f 1 -d" ")

        if [[ ${file} == *public/dev/lib/libs-less/* ]]; then

            find="public/dev/lib/libs-less/"
            replace="public/min/lib/libs-css/"
            minCssLibFile=${file//${find}/${replace}}

            find=".less"
            replace=".min.css"
            minCssLibFile=${minCssLibFile//${find}/${replace}}

            if [[ ! -f ${minCssLibFile} ]]; then
                mkdir -p ${minCssLibFile%/*}
                touch ${minCssLibFile}
                cd ~/Repos/Nimzo/
                git add ${minCssLibFile}
                minCssLibFileLMT=0
            else
                minCssLibFileLMT=$(stat -f "%m %N" ${minCssLibFile} | cut -f 1 -d" ")
            fi

            if [[ ${devCssLMT} > ${minCssLibFileLMT} ]]; then
                lessc ${file} > ${minCssLibFile} -x -s
            fi

        else

            # If even ONE .less files is newer than the global minizmed CSS (app.min.css), re-compile the lot & exit loop
            if [[ ${devCssLMT} > ${minCssLMT} ]]; then

                cd ~/Repos/Nimzo

                # Re-create the compiled .css file. (if doesn't exist)
                minCssFile="/Users/Albert/Repos/Nimzo/httpdocs/public/min/lib/css/app.min.css"
                if [[ ! -f ${minCssFile} ]]; then
                    mkdir -p ${minCssFile%/*}
                    touch ${minCssFile}
                    cd ~/Repos/Nimzo/
                    git add ${minCssFile}
                fi

                # Compile to Less into CSS
                cd ~/Repos/Nimzo/httpdocs
                lessc public/dev/lib/app-less/app.less > public/min/lib/app-css/app.css
                lessc public/dev/lib/app-less/app.less > ${minCssFile} -x -s

                # Break out of script, we only need to do this once.
                break
            fi
        fi
    fi
done