#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh
. ~/Repos/Scripts/bash/common/nimzo.sh

controllerName=$1

validateControllerName

ruby ~/Repos/Scripts/ruby/nimzo/nimzo-create-remove.rb ${controllerName} app delete