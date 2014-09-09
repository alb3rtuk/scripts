#!/bin/sh
# Renames all files in current directory sequentially.

. ~/Repos/Scripts/bash/common/utilities.sh

prefix=$1
cnt=0

for fname in *
do
    cnt=$((${cnt} + 1))
    cntDisplay=$(printf %02d ${cnt})
    ext="${fname##*.}"
    mv ${fname} ${prefix}${cntDisplay}.${ext}
    echo "\033[32m${prefix}${cntDisplay}.${ext}\033[0m < \033[37m${fname}\033[0m"
done