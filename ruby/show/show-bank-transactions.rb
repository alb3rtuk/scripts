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

        # Get banks into Hash
        @banks = {}
        banksSQL = @databaseConnection.query('SELECT * FROM bank ORDER BY id ASC')
        banksSQL.each_hash do |row|
            @banks[row['id']] = row['title']
        end
        banksSQL.free

        @colWidth1 = 15
        @colWidth2 = 20
        @colWidth_3 = 12
        @colWidth_4 = 12
        @colWidth_5 = 12
        @colWidth_6 = 20
        @colWidth_7 = 20
        @colWidth_8 = 22
        @colWidth_9 = 10
        @colWidthTotal = @colWidth1 + @colWidth2 + @colWidth_3 + @colWidth_4 + @colWidth_5 + @colWidth_6 + @colWidth_7 + @colWidth_8 + @colWidth_9 + 8

    end

    # Main function
    def run

        puts "\n"
        displayBankAccounts
        displayCreditCards
        puts "\n"
    end

    # Display Bank Accounts
    def displayBankAccounts
        puts "#{Rainbow(' BANK ACCOUNTS ').background('#ff008a')}"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @colWidth1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @colWidth2, :align => 'left')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Overdraft', :width => @colWidth_5, :align => 'right')
                column('', :width => @colWidth_6, :align => 'right')
                column('', :width => @colWidth_7, :align => 'right')
                column('Last Fetch', :width => @colWidth_8, :align => 'right')
                column('Age', :width => @colWidth_9, :align => 'left')
            end
            row do
                column(getRuleString(@colWidth1))
                column(getRuleString(@colWidth2))
                column(getRuleString(@colWidth_3))
                column(getRuleString(@colWidth_4))
                column(getRuleString(@colWidth_5))
                column(getRuleString(@colWidth_6))
                column(getRuleString(@colWidth_7))
                column(getRuleString(@colWidth_8))
                column(getRuleString(@colWidth_9))
            end
            bankAccounts = @databaseConnection.query("SELECT * FROM bank_account WHERE bank_account_type_id='1' ORDER BY bank_id, id ASC")
            bankAccounts.each_hash do |row|
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
                        column('')
                        column('')
                        column("#{balances['date_fetched']}")
                        column('N/A')
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n\n"
    end

    # Display CreditCards
    def displayCreditCards
        puts "#{Rainbow(' CREDIT CARDS ').background('#ff008a')}"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @colWidth1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @colWidth2, :align => 'left')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Limit', :width => @colWidth_5, :align => 'right')
                column('Minimum Payment', :width => @colWidth_6, :align => 'right')
                column('Payment Date', :width => @colWidth_7, :align => 'right')
                column('Last Fetch', :width => @colWidth_8, :align => 'right')
                column('Age', :width => @colWidth_9, :align => 'left')
            end
            row do
                column(getRuleString(@colWidth1))
                column(getRuleString(@colWidth2))
                column(getRuleString(@colWidth_3))
                column(getRuleString(@colWidth_4))
                column(getRuleString(@colWidth_5))
                column(getRuleString(@colWidth_6))
                column(getRuleString(@colWidth_7))
                column(getRuleString(@colWidth_8))
                column(getRuleString(@colWidth_9))
            end
            bankAccounts = @databaseConnection.query("SELECT * FROM bank_account WHERE bank_account_type_id='2' ORDER BY bank_id, id ASC")
            bankAccounts.each_hash do |row|
                if row['bank_account_type_id'].to_i == 2
                    bankAndColor = getBankAndColor(row['bank_id'])
                    balances = @databaseConnection.query("SELECT * FROM bank_account_type_credit_card WHERE bank_account_id='#{row['id']}'")
                    balances = balances.fetch_hash
                    row do
                        column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                        column(row['title'], :color => bankAndColor[1])
                        column(getAsCurrency(balances['balance'])[0], :color => getAsCurrency(balances['balance'])[1])
                        column(getAsCurrency(balances['balance_available'])[0])
                        column(getAsCurrency(balances['balance_limit'])[0])
                        column(getAsCurrency(balances['minimum_payment'])[0])
                        column(balances['minimum_payment_date'])
                        column("#{balances['date_fetched']}")
                        column('N/A')
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n\n"
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