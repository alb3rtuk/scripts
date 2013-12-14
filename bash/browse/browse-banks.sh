#!/bin/sh

# Script to open Bank Accounts / Credit Card.
# Not passing parameter opens all, passing parameter opens a specific account only.
# Available parameters are: halifax, lloyds, natwest, barclaycard, capitalone

cd ~/Repos/Scripts/ruby/
ruby bank-accounts.rb $1