#!/bin/sh

type=$1
route=$2

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/nimzo/common/nimzo.sh

# Continue to ruby..
ruby ~/Repos/Scripts/ruby/nimzo/nimzo-create-remove.rb ${type} ${route} remove