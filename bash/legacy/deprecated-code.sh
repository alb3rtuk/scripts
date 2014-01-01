#!/bin/sh

# FILE FOR DE-PRECATED CODE FOR LATER REFERENCE, ETC.

# The (deprecated) Pay Credit Card script. This was sooo hacky!
function payCreditCard()
{
    acc1=$1
    acc2=$2

    account="0"
    while [ $account != "1" ] && [ $account != "2" ]; do
        read -p "`echo "\033[37m"`What account would you like to make the payment from?`echo "\033[0m"` => " -r
        if [[ $REPLY =~ ^[1]$ ]]; then
            echo
            message blue "ACC" "\033[33m$acc1\033[0m"
            account=1
        elif [[ $REPLY =~ ^[2]$ ]]; then
            echo
            message blue "Acc" "\033[33m$acc2\033[0m"
            account=2
        fi
        echo
    done

    amount="0"
    amountValid="0"
    while [ $amountValid == "0" ]; do
        read -p "`echo "\033[37m"`How much would you like to pay? [ie: 15.00]`echo "\033[0m"` => " -r
        amount=$REPLY
        if [[ "$amount" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            amount="`printf "%0.2f\n" $amount`"
            echo
            message blue "PAY" "\033[33m£$amount\033[0m"
            amountValid="1"
        fi
        echo
    done

    actionConfirmed="0"
    while [ $actionConfirmed == "0" ]; do
        read -p "`echo "\033[37m"`You are about to make a payment of `echo "\033[33m£$amount\033[0m"`. Once started, the process cannot be aborted.`echo "\033[0m\n\n\033[42m Confirm \033[40m\033[32m"` Are you absolutely sure you want to continue? `echo "\033[37m"`[y/n]`echo "\033[0m"` `echo "\033[0m"` => " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            actionConfirmed="1"
        else
            read -p "`echo "\033[37m"`Abort? [y/n]`echo "\033[0m"` => " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "\n"
                actionConfirmed="1"
                exit
            else
                echo "\n"
            fi
        fi
    done
}