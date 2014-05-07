#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clear

echo
message cyan " ROUTES " "Getting routes..."

ruby ~/Repos/Scripts/ruby/nimzo/nimzo-get-routes.rb $1