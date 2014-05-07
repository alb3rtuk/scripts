#!/bin/sh

. ~/Repos/Scripts/bash/common/utilities.sh

clear

echo
message cyan " ROUTES " "Available route(s):"

ruby ~/Repos/Scripts/ruby/nimzo/nimzo-show-routes.rb $1