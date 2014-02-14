#!/bin/sh

size=$1

find find . -type f -size +${size}000c -exec ls -la {} \;