require 'rubygems'
require 'mysql'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'

class ShowBankTransactions
    include CommandLineReporter

    # Initialize all the DB stuff, etc.
    def initialize

        # Get Database Connection
        encrypter = Encrypter.new
        @databaseConnection = Mysql.new(
            encrypter.decrypt(EC2MySqlAlb3rtukHost),
            encrypter.decrypt(EC2MySqlAlb3rtukUser),
            encrypter.decrypt(EC2MySqlAlb3rtukPass),
            encrypter.decrypt(EC2MySqlAlb3rtukSchema)
        )

        @rule = getRuleString(202)

        # Get bank account data SQL result (array)
        @bankAccounts = @databaseConnection.query('SELECT * FROM bank_account ORDER BY bank_id, id ASC')

        # Get banks into Hash
        @banks = {}
        banksSQL = @databaseConnection.query('SELECT * FROM bank ORDER BY id ASC')
        banksSQL.each_hash do |row|
            @banks[row['id']] = row['title']
        end
        banksSQL.free

        @balanceDisplayColumnWidth_1 = 15
        @balanceDisplayColumnWidth_2 = 20
        @balanceDisplayColumnWidth_3 = 12
        @balanceDisplayColumnWidth_4 = 12
        @balanceDisplayColumnWidth_5 = 12
        @balanceDisplayColumnWidth_6 = 30
        @balanceDisplayColumnWidth_7 = 10


    end

    # Main function
    def run

        puts "\n"
        displayBankAccounts
        puts "\n"
    end

    # Display Bank Accounts
    def displayBankAccounts
        puts "#{Rainbow(' BANK ACCOUNTS ').background('#ff008a')}"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @balanceDisplayColumnWidth_1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @balanceDisplayColumnWidth_2, :align => 'left')
                column('Balance', :width => @balanceDisplayColumnWidth_3, :align => 'right')
                column('Available', :width => @balanceDisplayColumnWidth_4, :align => 'right')
                column('Overdraft', :width => @balanceDisplayColumnWidth_5, :align => 'right')
                column('Last Fetch', :width => @balanceDisplayColumnWidth_6, :align => 'right')
                column('Age', :width => @balanceDisplayColumnWidth_7, :align => 'left')
            end
            row do
                column(getRuleString(@balanceDisplayColumnWidth_1))
                column(getRuleString(@balanceDisplayColumnWidth_2))
                column(getRuleString(@balanceDisplayColumnWidth_3))
                column(getRuleString(@balanceDisplayColumnWidth_4))
                column(getRuleString(@balanceDisplayColumnWidth_5))
                column(getRuleString(@balanceDisplayColumnWidth_6))
                column(getRuleString(@balanceDisplayColumnWidth_7))
            end
            @bankAccounts.each_hash do |row|
                if row['bank_account_type_id'].to_i == 1
                    bankAndColor = getBankAndColor(row['bank_id'])
                    balances = @databaseConnection.query("SELECT * FROM bank_account_type_bank_account WHERE bank_account_id='#{row['id']}'")
                    balances = balances.fetch_hash

                    row do
                        column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                        column(row['title'], :color => bankAndColor[1])
                        column(getAsCurrency(balances['balance'])[0], :color => getAsCurrency(balances['balance'])[1])
                        column(getAsCurrency(balances['balance_available'])[0])
                        column(getAsCurrency(balances['balance_overdraft'])[0])
                        column("  #{balances['date_fetched']}")
                        column('N/A')
                    end
                end
            end
        end

    end

    # Returns name of bank account + associated color.
    def getBankAndColor(bankId)
        returnHash = {}
        returnHash[0] = @banks[bankId.to_s]
        case bankId.to_i
            when 1
                returnHash[1] = 'magenta'
            when 2
                returnHash[1] = 'blue'
            when 3
                returnHash[1] = 'green'
            when 4
                returnHash[1] = 'yellow'
            when 4
                returnHash[1] = 'cyan'
            else
                returnHash[1] = 'white'
        end
        returnHash
    end

    # Returns '━━━━'
    def getRuleString(length)
        ruleString = ''
        for i in 0..length - 1

            ruleString = "#{ruleString}━"
        end
        ruleString
    end

    # Returns the amount as currency formatted string with color (as hash)
    def getAsCurrency(amount, symbol = '£', delimiter = ',')
        amount = amount.to_f
        returnHash = {}

        # Set index '1' to color
        if amount < 0
            returnHash[1] = 'red'
        else
            returnHash[1] = 'green'
        end

        # Set index '0' to formatted amount
        minus = (amount < 0) ? '-' : ''
        amount = '%.2f' % amount.abs
        amount = amount.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
        returnHash[0] = "#{minus}#{symbol}#{amount}"
        returnHash
    end

end

ShowBankTransactions.new.run