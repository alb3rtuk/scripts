#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

# Must go to path so parameters are correct.
cd ~/Repos/Nimzo-Ruby/tests

ruby ~/Repos/Nimzo-Ruby/tests/TestRunner.rb true $1