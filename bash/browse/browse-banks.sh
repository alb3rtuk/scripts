#!/bin/sh

# Script to open Bank Accounts / Credit Card.
# Not passing parameter opens all, passing parameter opens a specific account only.
# Available parameters are: halifax, lloyds, natwest, barclaycard, capitalone

. ~/Repos/Scripts/bash/common/common-detect-displays.sh

ruby ~/Repos/Scripts/ruby/browse/browse-banks.rb $displays $1