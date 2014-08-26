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

        # Get bank account into Hash
        @bankAccounts = {}
        bankAccountsSQL = @databaseConnection.query('SELECT * FROM bank_account ORDER BY id ASC')
        bankAccountsSQL.each_hash do |row|
            @bankAccounts[row['id']] = row
        end
        bankAccountsSQL.free

        # Column widths for transactions
        @transWidth_1 = 20
        @transWidth_2 = 20

        @transWidth_3 = 14
        @transWidth_4 = 6
        @transWidth_5 = 109
        @transWidth_6 = 13
        @transWidth_7 = 13
        @transWidthTotal = @transWidth_1 + @transWidth_2 + @transWidth_3 + @transWidth_4 + @transWidth_5 + @transWidth_6 + @transWidth_7 + 8

        # Column widths for balances
        @colWidth_1 = 20
        @colWidth_2 = 25
        @colWidth_3 = 20
        @colWidth_4 = 20
        @colWidth_5 = 20
        @colWidth_6 = 20
        @colWidth_7 = 20
        @colWidth_8 = 21
        @colWidth_9 = 27
        @colWidthTotal = @colWidth_1 + @colWidth_2 + @colWidth_3 + @colWidth_4 + @colWidth_5 + @colWidth_6 + @colWidth_7 + @colWidth_8 + @colWidth_9 + 8

        @pastMonthDeployed = false
        @pastWeekDeployed = false
        @past48HoursDeployed = false

    end

    # Main function
    def run
        puts "\n"
        displayTransactions
        displayCreditCards
        displayBankAccounts
        puts "\n"
    end

    # Display Transactions
    def displayTransactions
        puts "#{Rainbow(' TRANSACTIONS ').background('#ff008a')}\n\n"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @transWidth_1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @transWidth_2, :align => 'left')
                column('Date', :width => @transWidth_3, :align => 'left')
                column('Type', :width => @transWidth_4, :align => 'left')
                column('Description', :width => @transWidth_5, :align => 'right')
                column('Paid In', :width => @transWidth_6, :align => 'right')
                column('Paid Out', :width => @transWidth_7, :align => 'right')
            end
            row do
                column(getRuleString(@transWidth_1))
                column(getRuleString(@transWidth_2))
                column(getRuleString(@transWidth_3))
                column(getRuleString(@transWidth_4))
                column(getRuleString(@transWidth_5))
                column(getRuleString(@transWidth_6))
                column(getRuleString(@transWidth_7))
            end
            transactions = @databaseConnection.query('SELECT * FROM bank_account_transactions WHERE date > DATE_SUB(CURDATE(), INTERVAL 45 DAY) ORDER BY date ASC, bank_account_id ASC, type ASC')
            transactions.each_hash do |transaction|
                bankAndColor = getBankAndColor(@bankAccounts[transaction['bank_account_id']]['bank_id'])

                timeStamp = DateTime.strptime(transaction['date'], '%Y-%m-%d')
                timeNow = DateTime.now
                timeAgo = ((timeNow - timeStamp) * 24 * 60 * 60).to_i

                if timeAgo < 172800
                    displayTransactionsDeployPast48Hours
                elsif timeAgo < 604608
                    displayTransactionsDeployPastWeek
                elsif timeAgo < 2626560
                    displayTransactionsDeployPastMonth
                end

                if isInternalTransfer(transaction)
                    next
                    # transactionColor = 'yellow'
                    # transactionIsInternal = true
                else
                    transactionColor = 'white'
                    transactionIsInternal = false
                end


                row do
                    column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                    column(@bankAccounts[transaction['bank_account_id']]['title'], :color => bankAndColor[1])
                    column(timeStamp.strftime('%d %b %Y'), :color => transactionColor)
                    column(transaction['type'], :color => transactionColor)
                    column(transaction['description'][0..(@transWidth_5 - 2)], :color => transactionColor)
                    column((transaction['paid_in'].to_f == 0) ? '' : getAsCurrency(transaction['paid_in'])[0], :color => (transactionIsInternal) ? 'yellow' : 'cyan')
                    column((transaction['paid_out'].to_f == 0) ? '' : getAsCurrency(0 - transaction['paid_out'].to_f)[0], :color => (transactionIsInternal) ? 'yellow' : 'red')
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n"
    end

    # Returns TRUE if transaction is internal transfer
    # @boolean
    def isInternalTransfer(transaction)

        if transaction['bank_account_id'].to_i >= 1 && transaction['bank_account_id'].to_i <= 3

            # IF NATWEST
            terms1 = Array[
                'A RANNETSPERGER , LLOYDS ACCOUNT',
                'HALIFAX ULTIMATE',
                'AR HALIFAX ACC',
                'LLOYDS ACCOUNT',
            ]
            terms2 = Array[
                'CALL REF.NO.'
            ]
            if (transaction['type'] == 'BAC') && terms1.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'OTR') && terms2.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            end

        elsif transaction['bank_account_id'].to_i >= 7 && transaction['bank_account_id'].to_i <= 8

            # IF LLOYDS
            terms1 = Array[
                'NATWEST AD GOLD',
                'NATWEST STEP',
                'NATWEST SAVINGS',
                'LLOYDS BANK PLATIN',
            ]
            terms2 = Array[
                'RANNETSPERGER A NATWEST'
            ]
            terms3 = Array[
                'HALIFAX ULTIMATE',
                'HALIFAX REWARD',
                'A RANNETSPERGER',
            ]
            terms4 = Array[
                'PAYMENT RECEIVED'
            ]
            if (transaction['type'] == 'FPO') && terms1.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'FPI') && terms2.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'TFR') && terms3.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'CC') && terms4.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            end

        elsif transaction['bank_account_id'].to_i >= 4 && transaction['bank_account_id'].to_i <= 5

            # IF HALIFAX
            terms1 = Array[
                'NATWEST AD GOLD',
                'NATWEST STEP',
                'NATWEST SAVINGS',
            ]
            terms2 = Array[
                'RANNETSPERGER A NATWEST'
            ]
            terms3 = Array[
                'HALIFAX ULTIMATE',
                'HALIFAX REWARD',
                'A RANNETSPERGER',
            ]
            if (transaction['type'] == 'FPO') && terms1.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'FPI') && terms2.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            elsif (transaction['type'] == 'TFR') && terms3.any? { |w| transaction['description'] =~ /#{w}/ }
                return true
            end

        end
    end

    def displayTransactionsDeployPastMonth
        unless @pastMonthDeployed
            displayTransactionsBlankRow
            row do
                @pastMonthDeployed = true
                column("\x1B[46m PAST MONTH \x1B[0")
                column('')
                column('')
                column('')
                column('')
                column('')
                column('')
            end
            displayTransactionsBlankRow
        end
    end

    def displayTransactionsDeployPastWeek
        unless @pastWeekDeployed
            displayTransactionsBlankRow
            row do
                @pastWeekDeployed = true
                column("\x1B[46m PAST WEEK \x1B[0")
                column('')
                column('')
                column('')
                column('')
                column('')
                column('')
            end
            displayTransactionsBlankRow
        end
    end

    def displayTransactionsDeployPast48Hours
        unless @past48HoursDeployed
            displayTransactionsBlankRow
            row do
                @past48HoursDeployed = true
                column("\x1B[46m PAST 48 HOURS \x1B[0")
                column('')
                column('')
                column('')
                column('')
                column('')
                column('')
            end
        end
    end

    def displayTransactionsBlankRow
        row do
            column('')
            column('')
            column('')
            column('')
            column('')
            column('')
            column('')
        end
    end

    # Display Bank Accounts
    def displayBankAccounts
        puts "#{Rainbow(' BANK ACCOUNTS ').background('#ff008a')}\n\n"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @colWidth_1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @colWidth_2, :align => 'left')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Overdraft', :width => @colWidth_5, :align => 'right')
                column('—', :width => @colWidth_6, :align => 'right')
                column('—', :width => @colWidth_7, :align => 'right')
                column('', :width => @colWidth_8, :align => 'right')
                column('', :width => @colWidth_9, :align => 'right')
            end
            row do
                column(getRuleString(@colWidth_1))
                column(getRuleString(@colWidth_2))
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
                    balances = @databaseConnection.query("SELECT * FROM bank_account_type_bank_account WHERE bank_account_id='#{row['id']}' ORDER BY date_fetched DESC LIMIT 1")
                    balances = balances.fetch_hash
                    balances['date_fetched_string'] = normalizeTimestamp(balances['date_fetched_string'])
                    row do
                        column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                        column(row['title'], :color => bankAndColor[1])
                        column(getAsCurrency(balances['balance'])[0], :color => getAsCurrency(balances['balance'])[1])
                        column(getAsCurrency(balances['balance_available'])[0], :color => 'white')
                        column(getAsCurrency(balances['balance_overdraft'])[0], :color => 'white')
                        column('—', :color => 'white')
                        column('—', :color => 'white')
                        column("#{formatTimestamp(balances['date_fetched_string'])}", :color => 'white')
                        column("#{getTimeAgoInHumanReadable(balances['date_fetched_string'])}", :color => 'yellow')
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n"
    end

    # Display CreditCards
    def displayCreditCards
        puts "#{Rainbow(' CREDIT CARDS ').background('#ff008a')}\n\n"
        table(:border => false) do
            row do
                column(' Bank Name', :width => @colWidth_1, :align => 'left', :bold => 'true')
                column('Account Name', :width => @colWidth_2, :align => 'left')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Limit', :width => @colWidth_5, :align => 'right')
                column('Minimum Payment', :width => @colWidth_6, :align => 'right')
                column('Payment Date', :width => @colWidth_7, :align => 'right')
                column('', :width => @colWidth_8, :align => 'right')
                column('', :width => @colWidth_9, :align => 'right')
            end
            row do
                column(getRuleString(@colWidth_1))
                column(getRuleString(@colWidth_2))
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
                    balances = @databaseConnection.query("SELECT * FROM bank_account_type_credit_card WHERE bank_account_id='#{row['id']}' ORDER BY date_fetched DESC LIMIT 1")
                    balances = balances.fetch_hash
                    balances['date_fetched_string'] = normalizeTimestamp(balances['date_fetched_string'])
                    row do
                        column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                        column(row['title'], :color => bankAndColor[1])
                        creditCardBalance = 0 - balances['balance'].to_f

                        minimumPaymentDate = balances['minimum_payment_date']
                        if minimumPaymentDate == '0000-00-00'
                            minimumPaymentDate = '1983-10-29'
                        end
                        timeStamp = DateTime.strptime(minimumPaymentDate, '%Y-%m-%d')
                        timeNow = DateTime.now
                        minimumPaymentDateIn = (timeStamp - timeNow).to_i
                        if minimumPaymentDateIn <= 3
                            minimumPaymentColor = 'red'
                        else
                            minimumPaymentColor = 'white'
                        end

                        column(getAsCurrency(creditCardBalance)[0], :color => (getAsCurrency(creditCardBalance)[1] == 'red') ? 'red' : 'white')
                        column(getAsCurrency(balances['balance_available'])[0], :color => 'white')
                        column(getAsCurrency(balances['balance_limit'])[0], :color => 'white')
                        column(getAsCurrency(balances['minimum_payment'])[0], :color => (balances['minimum_payment'].to_f > 0) ? ((minimumPaymentDateIn <= 3) ? 'red' : 'white') : 'white')
                        if minimumPaymentDateIn < 0
                            column('—', :color => 'white')
                        else
                            column("#{DateTime.strptime(minimumPaymentDate, '%Y-%m-%d').strftime('%d %b')} [#{minimumPaymentDateIn} days]", :color => minimumPaymentColor)
                        end
                        column("#{formatTimestamp(balances['date_fetched_string'])}", :color => 'white')
                        column("#{getTimeAgoInHumanReadable(balances['date_fetched_string'])}", :color => 'yellow')
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n"
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

    # If timestamp is blank, this gives it a normalized timestamp so script doesn't error.
    def normalizeTimestamp(timestamp)
        if timestamp == '0000-00-00 00:00:00' || timestamp == '0000-00-00T00:00:00+00:00'
            timestamp = '1983-10-29T03:16:00+00:00'
        end
        timestamp
    end

end

# Make sure we're online before we start
checkMachineIsOnline

ShowBankTransactions.new.run