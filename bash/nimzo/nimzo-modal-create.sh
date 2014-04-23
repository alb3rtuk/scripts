#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/common/nimzo.sh

controllerName=$1

validateControllerName

ruby ~/Repos/Scripts/ruby/nimzo/nimzo-create-delete.rb ${controllerName} modal create