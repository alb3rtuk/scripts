#!/bin/sh

# Script to open Bank Accounts / Credit Card.
# Not passing parameter opens all, passing parameter opens a specific account only.
# Available parameters are: halifax, lloyds, natwest, barclaycard, capitalone

ruby ~/Repos/Scripts/ruby/browse/browse-banks.rb $1