require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'

class ShowBankTransactions
    include CommandLineReporter

    # Initialize all the DB stuff, etc.
    def initialize(argv)

        # Get Database Connection
        encrypter = Encrypter.new
        @databaseConnection = Mysql.new(
            encrypter.decrypt(EC2MySqlAlb3rtukHost),
            encrypter.decrypt(EC2MySqlAlb3rtukUser),
            encrypter.decrypt(EC2MySqlAlb3rtukPass),
            encrypter.decrypt(EC2MySqlAlb3rtukSchema)
        )

        @recognizedTransactions = Array[
            # NATWEST AD GOLD
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['PAYPAL', 'PPWD'], :color => 'white', :translation => 'PAYPAL WITHDRAWAL', :recurring => false},
            {:bank_account_id => 1, :type => '-  ', :terms => Array['521005', '521007'], :color => 'green', :translation => 'CASH', :recurring => false},
            {:bank_account_id => 1, :type => 'D/D', :terms => Array['NAMES.CO.UK'], :color => 'red', :translation => 'NAMESCO WEB SERVER', :recurring => true, :recurring_direction => 'out', :recurring_amount => 29.99},
            {:bank_account_id => 1, :type => 'D/D', :terms => Array['SLMLTD INCOME AC'], :color => 'red', :translation => 'HORFIELD SPORTS CENTRE SUBSCRIPTION', :recurring => true, :recurring_direction => 'out', :recurring_amount => 29.99},
            {:bank_account_id => 1, :type => 'D/D', :terms => Array['UK MAIL'], :color => 'white', :translation => 'UK MAIL', :recurring => false},
            {:bank_account_id => 1, :type => 'POS', :terms => Array['UK MAIL'], :color => 'white', :translation => 'UK MAIL', :recurring => false},
            {:bank_account_id => 1, :type => 'OTR', :terms => Array['07519616416'], :color => 'white', :translation => 'ROSS JOY', :recurring => false},
            {:bank_account_id => 1, :type => 'OTR', :terms => Array['07980286590', 'SCOULDING L A'], :color => 'white', :translation => 'LUKE SCOULDING', :recurring => false},
            {:bank_account_id => 1, :type => 'OTR', :terms => Array['07825126363'], :color => 'white', :translation => 'LUKE CHAMBERLAIN', :recurring => false},
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['D LINDEN'], :color => 'white', :translation => 'DEAN LINDEN', :recurring => false},
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['G SOLAN , VIRGIN TV'], :color => 'cyan', :translation => 'GARY SOLAN (VIRGIN MEDIA)', :recurring => true, :recurring_direction => 'in', :recurring_amount => 30},
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['G SOLAN'], :color => 'white', :translation => 'GARY SOLAN', :recurring => false},
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['ALEX CARLIN'], :color => 'white', :translation => 'ALEX CARLIN', :recurring => false},
            {:bank_account_id => 1, :type => 'BAC', :terms => Array['J HARTRY '], :color => 'white', :translation => 'JOE HARTRY', :recurring => false},
            {:bank_account_id => 1, :type => 'POS', :terms => Array['SPOTIFY'], :color => 'red', :translation => 'SPOTIFY SUBSCRIPTION', :recurring => true, :recurring_direction => 'out', :recurring_amount => 19.98},
            {:bank_account_id => 1, :type => 'POS', :terms => Array['LYNDA.COM'], :color => 'red', :translation => 'LYNDA.COM SUBSCRIPTION', :recurring => true, :recurring_direction => 'out', :recurring_amount => 16},
            {:bank_account_id => 1, :type => 'POS', :terms => Array['GITHUB.COM'], :color => 'red', :translation => 'GITHUB.COM SUBSCRIPTION', :recurring => true, :recurring_direction => 'out', :recurring_amount => 8.50},
            {:bank_account_id => 1, :type => 'POS', :terms => Array['TRANSFERWISE'], :color => 'white', :translation => 'TRANFERWISE (WEDDING FUND)', :recurring => false},
            # NATWEST SAVINGS
            {:bank_account_id => 3, :type => 'BAC', :terms => Array['TRANSFERWISE'], :color => 'white', :translation => 'TRANFERWISE (REFUND)', :recurring => false},
            # HALIFAX ULTIMATE REWARD
            {:bank_account_id => 4, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => 'red', :translation => 'ACCOUNT FEE', :recurring => true, :recurring_direction => 'out', :recurring_amount => 15},
            # HALIFAX REWARD
            {:bank_account_id => 5, :type => 'DEB', :terms => Array['CREDITEXPERT.CO.UK'], :color => 'red', :translation => 'CREDITEXPERT SUBSCRIPTION', :recurring => true, :recurring_direction => 'out', :recurring_amount => 9.99},
            # LLOYDS CURRENT
            {:bank_account_id => 8, :type => 'FPO', :terms => Array['STELLA TALIOTIS'], :color => 'red', :translation => 'RENT', :recurring => true, :recurring_direction => 'out', :recurring_amount => 250},
            {:bank_account_id => 8, :type => 'DD', :terms => Array['VODAFONE LIMITED'], :color => 'red', :translation => 'VODAFONE LIMITED', :recurring => true, :recurring_direction => 'out', :recurring_amount => 60},
            {:bank_account_id => 8, :type => 'DD', :terms => Array['VIRGIN MEDIA'], :color => 'red', :translation => 'VIRGIN MEDIA', :recurring => true, :recurring_direction => 'out', :recurring_amount => 110},
            {:bank_account_id => 8, :type => 'CSH', :terms => Array[''], :color => 'green', :translation => 'CASH', :recurring => false},
            {:bank_account_id => 8, :type => 'DD', :terms => Array['TESCO BANK'], :color => 'red', :translation => 'TESCO CAR INSURANCE', :recurring => true, :recurring_direction => 'out', :recurring_amount => 0},
            {:bank_account_id => 8, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => 'red', :translation => 'ACCOUNT FEE', :recurring => true, :recurring_direction => 'out', :recurring_amount => 15},
            {:bank_account_id => 8, :type => 'FPI', :terms => Array['MATTHEW JONES'], :color => 'cyan', :translation => 'MATT JONES (VIRGIN MEDIA)', :recurring => true, :recurring_direction => 'in', :recurring_amount => 24},
        ]

        @internalTransfers = Array[
            # NATWEST
            {:bank_account_id => Array[1, 2, 3], :type => 'BAC', :terms => Array['A RANNETSPERGER', 'HALIFAX ULTIMATE', 'AR HALIFAX ACC', 'LLOYDS ACCOUNT']},
            {:bank_account_id => Array[1, 2, 3], :type => 'OTR', :terms => Array['CALL REF.NO.']},
            {:bank_account_id => Array[1, 2, 3], :type => 'POS', :terms => Array['BARCLAYCARD', 'CAPITAL ONE']},
            # LLOYDS
            {:bank_account_id => Array[8], :type => 'FPO', :terms => Array['NATWEST AD GOLD', 'NATWEST STEP', 'NATWEST SAVINGS', 'LLOYDS BANK PLATIN']},
            {:bank_account_id => Array[8], :type => 'FPI', :terms => Array['RANNETSPERGER A NATWEST']},
            {:bank_account_id => Array[8], :type => 'TFR', :terms => Array['HALIFAX ULTIMATE', 'HALIFAX REWARD', 'A RANNETSPERGER']},
            {:bank_account_id => Array[7], :type => 'CC', :terms => Array['PAYMENT RECEIVED']},
            # HALIFAX
            {:bank_account_id => Array[4, 5], :type => 'FPO', :terms => Array['NATWEST']},
            {:bank_account_id => Array[4, 5], :type => 'FPI', :terms => Array['RANNETSPERGER A NATWEST']},
            {:bank_account_id => Array[4, 5], :type => 'TFR', :terms => Array['HALIFAX ULTIMATE', 'HALIFAX REWARD', 'A RANNETSPERGER']},
        ]

        @untranslated = false
        @withInternalTransfers = false

        # Get different modes.
        if argv == 'untranslated'
            @untranslated = true
        elsif argv == 'with-internal-transfers'
            @withInternalTransfers = true
        end

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
        @transWidth_3 = 12
        @transWidth_4 = 114
        @transWidth_5 = 6
        @transWidth_6 = 11
        @transWidth_7 = 12

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
                column('Account Name', :width => @transWidth_2, :align => 'left', :bold => 'true')
                column('Date', :width => @transWidth_3, :align => 'left')
                column('Description', :width => @transWidth_4, :align => 'right')
                column('', :width => @transWidth_5, :align => 'left', :bold => 'true')
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

            # Get first day of last month
            firstOfLastMonth = Time.new.to_datetime
            firstOfLastMonth = firstOfLastMonth << 2
            firstOfLastMonth = firstOfLastMonth.to_time.strftime('%Y-%m-01')

            last_date = nil

            transactions = @databaseConnection.query("SELECT * FROM bank_account_transactions WHERE date >= '#{firstOfLastMonth}' ORDER BY date ASC, bank_account_id ASC, type ASC")
            transactions.each_hash do |transaction|

                bankAndColor = getBankAndColor(@bankAccounts[transaction['bank_account_id']]['bank_id'])

                # Translation Handling
                transactionDetails = getDescriptionAndColor(transaction)
                transactionColor = transactionDetails[:color]
                if @untranslated
                    transactionDescription = transaction['description']
                else
                    transactionDescription = transactionDetails[:description]
                end

                # Internal Transfer Handling
                if isInternalTransfer(transaction)
                    if @withInternalTransfers
                        transactionColor = 'yellow'
                    else
                        next
                    end
                else
                    if @withInternalTransfers
                        transactionColor = 'white'
                    end
                end

                # Insert MONTH divider
                if last_date != nil
                    if DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%B') != DateTime.strptime(last_date, '%Y-%m-%d').strftime('%B')
                        displayTransactionsMonth(DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%B'))
                    else
                        # Insert space if new day
                        if last_date != transaction['date']
                            displayTransactionsBlankRow
                        end
                    end
                end

                # Shorten Description
                description = transactionDescription[0..(@transWidth_4 - 2)]

                row do
                    column(" #{bankAndColor[0]}", :color => bankAndColor[1])
                    column(@bankAccounts[transaction['bank_account_id']]['title'], :color => bankAndColor[1])
                    column(DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%d %b %Y'), :color => transactionColor)
                    column("#{description}", :color => transactionColor)
                    column(transaction['type'], :color => transactionColor)
                    column((transaction['paid_in'].to_f == 0) ? '' : getAsCurrency(transaction['paid_in'])[0], :color => transactionColor)
                    column((transaction['paid_out'].to_f == 0) ? '' : getAsCurrency(0 - transaction['paid_out'].to_f)[0], :color => transactionColor)
                end

                last_date = transaction['date']
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n"
    end

    # Translates Description
    # @return string
    def getDescriptionAndColor(transaction)
        @recognizedTransactions.each do |translation|
            if transaction['bank_account_id'].to_i == translation[:bank_account_id] && transaction['type'] == translation[:type] && translation[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                return {:description => translation[:translation].upcase, :color => translation[:color]}
            end
        end
        {:description => transaction['description'].upcase, :color => 'white'}
    end

    # Returns TRUE if transaction is internal transfer
    # @return boolean
    def isInternalTransfer(transaction)
        @internalTransfers.each do |match|
            if match[:bank_account_id].any? { |w| transaction['bank_account_id'] =~ /#{w}/ } && match[:terms].any? { |w| transaction['description'] =~ /#{w}/ } && match[:type] == transaction['type']
                return true
            end

        end
        false
    end

    # Inserts a divider to display the month
    # @return void
    def displayTransactionsMonth(month)
        displayTransactionsBlankRow
        row do
            @pastMonthDeployed = true
            column(getRuleString(@transWidth_1))
            column(getRuleString(@transWidth_2))
            column(getRuleString(@transWidth_3))
            column("#{getRuleString(@transWidth_4 - (month.length + 6))}  [ #{month.upcase} ]")
            column(getRuleString(@transWidth_5))
            column(getRuleString(@transWidth_6))
            column(getRuleString(@transWidth_7))
        end
        displayTransactionsBlankRow
    end

    # Displays a blank transaction row
    # @return void
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
                column('Account Name', :width => @colWidth_2, :align => 'left', :bold => 'true')
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
                column('Account Name', :width => @colWidth_2, :align => 'left', :bold => 'true')
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
    def getRuleString(length, delimiter = '━')
        ruleString = ''
        for i in 0..length - 1
            ruleString = "#{ruleString}#{delimiter}"
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

ShowBankTransactions.new(ARGV[0]).run