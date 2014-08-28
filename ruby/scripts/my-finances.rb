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

        # INTERNAL TYPE ID LEGEND
        # 1 => CASH IN
        # 2 => RECURRING IN
        # 3 => RECURRING OUT

        @recognizedTransactions = Array[
            # NATWEST AD GOLD
            {:intTypeID => 0, :id => 100, :bank_account_id => 1, :type => 'BAC', :terms => Array['PAYPAL', 'PPWD'], :color => 'white', :translation => 'PAYPAL WITHDRAWAL'},
            {:intTypeID => 1, :id => 200, :bank_account_id => 1, :type => '-  ', :terms => Array['521005', '521007', '560005'], :color => 'green', :translation => 'CASH'},
            {:intTypeID => 3, :id => 300, :bank_account_id => 1, :type => 'D/D', :terms => Array['NAMES.CO.UK'], :color => 'red', :translation => 'NAMESCO WEB SERVER', :recurring_amount => 29.99},
            {:intTypeID => 3, :id => 400, :bank_account_id => 1, :type => 'D/D', :terms => Array['SLMLTD INCOME AC'], :color => 'red', :translation => 'HORFIELD SPORTS CENTRE SUBSCRIPTION', :recurring_amount => 29.99},
            {:intTypeID => 0, :id => 500, :bank_account_id => 1, :type => 'D/D', :terms => Array['UK MAIL'], :color => 'white', :translation => 'UK MAIL'},
            {:intTypeID => 0, :id => 600, :bank_account_id => 1, :type => 'POS', :terms => Array['UK MAIL'], :color => 'white', :translation => 'UK MAIL'},
            {:intTypeID => 0, :id => 700, :bank_account_id => 1, :type => 'OTR', :terms => Array['07519616416'], :color => 'white', :translation => 'ROSS JOY'},
            {:intTypeID => 0, :id => 800, :bank_account_id => 1, :type => 'OTR', :terms => Array['07980286590', 'SCOULDING L A'], :color => 'white', :translation => 'LUKE SCOULDING'},
            {:intTypeID => 0, :id => 900, :bank_account_id => 1, :type => 'OTR', :terms => Array['07825126363'], :color => 'white', :translation => 'LUKE CHAMBERLAIN'},
            {:intTypeID => 0, :id => 1000, :bank_account_id => 1, :type => 'BAC', :terms => Array['D LINDEN'], :color => 'white', :translation => 'DEAN LINDEN'},
            {:intTypeID => 0, :id => 1100, :bank_account_id => 1, :type => 'BAC', :terms => Array['P HACKETT'], :color => 'white', :translation => 'PHIL HACKETT'},
            # "G SOLAN, VIRGIN TV" MUST BE BEFORE "G SOLAN"
            {:intTypeID => 2, :id => 1200, :bank_account_id => 1, :type => 'BAC', :terms => Array['G SOLAN , VIRGIN TV'], :color => 'cyan', :translation => 'GARY SOLAN (VIRGIN TV)', :recurring_amount => 30, :start_month => '2014-05'},
            {:intTypeID => 0, :id => 1300, :bank_account_id => 1, :type => 'BAC', :terms => Array['G SOLAN'], :color => 'white', :translation => 'GARY SOLAN'},
            {:intTypeID => 0, :id => 1400, :bank_account_id => 1, :type => 'BAC', :terms => Array['ALEX CARLIN'], :color => 'white', :translation => 'ALEX CARLIN'},
            {:intTypeID => 0, :id => 1500, :bank_account_id => 1, :type => 'BAC', :terms => Array['J HARTRY '], :color => 'white', :translation => 'JOE HARTRY'},
            {:intTypeID => 3, :id => 1600, :bank_account_id => 1, :type => 'POS', :terms => Array['SPOTIFY'], :color => 'red', :translation => 'SPOTIFY SUBSCRIPTION', :recurring_amount => 19.98},
            {:intTypeID => 3, :id => 1700, :bank_account_id => 1, :type => 'POS', :terms => Array['LYNDA.COM'], :color => 'red', :translation => 'LYNDA.COM SUBSCRIPTION', :recurring_amount => 16},
            {:intTypeID => 3, :id => 1800, :bank_account_id => 1, :type => 'POS', :terms => Array['GITHUB.COM'], :color => 'red', :translation => 'GITHUB.COM SUBSCRIPTION', :recurring_amount => 8.50},
            {:intTypeID => 0, :id => 1900, :bank_account_id => 1, :type => 'POS', :terms => Array['TRANSFERWISE'], :color => 'white', :translation => 'TRANFERWISE (WEDDING FUND)'},
            # NATWEST SAVINGS
            {:intTypeID => 0, :id => 2000, :bank_account_id => 3, :type => 'BAC', :terms => Array['TRANSFERWISE'], :color => 'white', :translation => 'TRANFERWISE (REFUND)'},
            # HALIFAX ULTIMATE REWARD
            {:intTypeID => 3, :id => 2100, :bank_account_id => 4, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => 'red', :translation => 'ACC. FEE (HALIFAX U/R)', :recurring_amount => 15},
            {:intTypeID => 1, :id => 2200, :bank_account_id => 4, :type => 'CSH', :terms => Array[''], :color => 'green', :translation => 'CASH'},
            # HALIFAX REWARD
            {:intTypeID => 3, :id => 2300, :bank_account_id => 5, :type => 'DEB', :terms => Array['CREDITEXPERT.CO.UK'], :color => 'red', :translation => 'CREDITEXPERT SUBSCRIPTION', :recurring_amount => 9.99},
            {:intTypeID => 0, :id => 2400, :bank_account_id => 5, :type => 'FPI', :terms => Array['PAYPAL WITHDRAWAL'], :color => 'white', :translation => 'PAYPAL WITHDRAWAL'},
            {:intTypeID => 1, :id => 2500, :bank_account_id => 5, :type => 'CSH', :terms => Array[''], :color => 'green', :translation => 'CASH'},
            # LLOYDS CURRENT
            {:intTypeID => 3, :id => 2600, :bank_account_id => 8, :type => 'FPO', :terms => Array['STELLA TALIOTIS'], :color => 'red', :translation => 'RENT', :recurring_amount => 250},
            {:intTypeID => 3, :id => 2700, :bank_account_id => 8, :type => 'DD', :terms => Array['VODAFONE LIMITED'], :color => 'red', :translation => 'VODAFONE LIMITED', :recurring_amount => 60},
            {:intTypeID => 3, :id => 2800, :bank_account_id => 8, :type => 'DD', :terms => Array['VIRGIN MEDIA'], :color => 'red', :translation => 'VIRGIN MEDIA', :recurring_amount => 110},
            {:intTypeID => 1, :id => 2900, :bank_account_id => 8, :type => 'CSH', :terms => Array[''], :color => 'green', :translation => 'CASH'},
            {:intTypeID => 3, :id => 3000, :bank_account_id => 8, :type => 'DD', :terms => Array['TESCO BANK'], :color => 'red', :translation => 'TESCO CAR INSURANCE', :recurring_amount => 0},
            {:intTypeID => 3, :id => 3100, :bank_account_id => 8, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => 'red', :translation => 'ACC. FEE (LLOYDS)', :recurring_amount => 15},
            {:intTypeID => 2, :id => 3200, :bank_account_id => 8, :type => 'FPI', :terms => Array['MATTHEW JONES'], :color => 'cyan', :translation => 'MATT JONES (VIRGIN TV)', :recurring_amount => 24},
        ]

        @recognizedTransactionsIndexedID = {}
        @recognizedTransactions.each do |recognizedTransaction|
            @recognizedTransactionsIndexedID["#{recognizedTransaction[:id]}"] = recognizedTransaction
        end

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

        # Load parameters
        @untranslated = false
        @withInternalTransfers = false

        # Misc Globals
        @rightHandSideCount = 0
        @rightHandSideContent = Array.new
        @rightHandSideContentCount = 0

        # Balance Globals
        @totalAvailable = 0
        @totalCredit = 0
        @totalCreditUsed = 0
        @totalCash = 0
        @summaryData = {
            :month1 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0},
            :month2 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0},
            :month3 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0},
            :month4 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0},
            :month5 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0},
        }

        # Months
        @month1 = DateTime.now
        @month2 = DateTime.now << 1
        @month3 = DateTime.now << 2
        @month4 = DateTime.now << 3
        @month5 = DateTime.now << 4

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

        # Get bank accounts into Hash
        @bankAccounts = {}
        bankAccountsSQL = @databaseConnection.query('SELECT * FROM bank_account ORDER BY id ASC')
        bankAccountsSQL.each_hash do |row|
            @bankAccounts[row['id']] = row
        end
        bankAccountsSQL.free

        # Get bank/credit card balances into Hash
        @bankAccountBalances = {}
        @bankAccounts.each do |bankAccount|
            bankAccount = bankAccount[1]
            case bankAccount['bank_account_type_id'].to_i
                when 1
                    bankAccountTable = 'bank_account_type_bank_account'
                when 2
                    bankAccountTable = 'bank_account_type_credit_card'
                when 3
                    bankAccountTable = 'bank_account_type_misc'
                else
                    raise(RuntimeError, "bank_account_type => #{bankAccount['bank_account_type']} doesn't exist.")
            end
            balance = @databaseConnection.query("SELECT * FROM #{bankAccountTable} WHERE bank_account_id='#{bankAccount['id']}' ORDER BY date_fetched DESC LIMIT 1")
            @bankAccountBalances[bankAccount['id'].to_i] = balance.fetch_hash
            balance.free
        end

        # Get transactions into Hash
        @transactions = Array.new
        # Get first day of last month
        firstOfLastMonth = Time.new.to_datetime
        firstOfLastMonth = firstOfLastMonth << 4
        firstOfLastMonth = firstOfLastMonth.to_time.strftime('%Y-%m-01')
        transactionsSQL = @databaseConnection.query("SELECT * FROM bank_account_transactions WHERE date >= '#{firstOfLastMonth}' ORDER BY date ASC, bank_account_id ASC, type ASC")
        transactionsSQL.each_hash do |transaction|
            @transactions << transaction
        end
        transactionsSQL.free

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

        # Column widths for balances
        @summaryWidth_1 = 46
        @summaryWidth_2 = 20
        @summaryWidth_3 = 20
        @summaryWidth_4 = 20
        @summaryWidth_5 = 20
        @summaryWidth_6 = 20
        @summaryWidth_7 = 21
        @summaryWidth_8 = 2
        @summaryWidth_9 = 24
        @summaryWidthTotal = @summaryWidth_1 + @summaryWidth_2 + @summaryWidth_3 + @summaryWidth_4 + @summaryWidth_5 + @summaryWidth_6 + @summaryWidth_7 + @summaryWidth_8 + @summaryWidth_9 + 8

    end

    # Main function
    def run
        # DO ALL CALCULATIONS
        getTotals
        getSummaryData

        # START OUTPUT
        displayTransactions
        displayCreditCards
        displayBankAccounts
        displaySummary
        puts "\n"
    end

    # Display Transactions
    def displayTransactions
        table(:border => false) do
            row do
                column(getRuleString(@transWidth_1), :width => @transWidth_1, :align => 'left', :bold => 'true')
                column(getRuleString(@transWidth_2), :width => @transWidth_2, :align => 'left', :bold => 'true')
                column(getRuleString(@transWidth_3), :width => @transWidth_3, :align => 'left')
                column(getRuleString(@transWidth_4), :width => @transWidth_4, :align => 'right')
                column(getRuleString(@transWidth_5), :width => @transWidth_5, :align => 'left', :bold => 'true')
                column(getRuleString(@transWidth_6), :width => @transWidth_6, :align => 'right')
                column(getRuleString(@transWidth_7), :width => @transWidth_7, :align => 'right')
            end
            row do
                column(' Bank Name')
                column('Account Name')
                column('Date')
                column('Description')
                column('')
                column('Paid In')
                column('Paid Out')
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

            last_date = nil
            @transactions.each do |transaction|

                # Determine Bank Text Color
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
            @bankAccounts.each do |row|
                row = row[1]
                if row['bank_account_type_id'].to_i == 1 && row['id'].to_i != 3
                    bankAndColor = getBankAndColor(row['bank_id'])
                    balances = @bankAccountBalances[row['id'].to_i]
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
        puts "#{getRuleString(@colWidthTotal)}\n\n"
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
            @bankAccounts.each do |row|
                row = row[1]
                if row['bank_account_type_id'].to_i == 2
                    bankAndColor = getBankAndColor(row['bank_id'])
                    balances = @bankAccountBalances[row['id'].to_i]
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
                            column("#{DateTime.strptime(minimumPaymentDate, '%Y-%m-%d').strftime('%d %b %Y')}", :color => minimumPaymentColor)
                        end
                        column("#{formatTimestamp(balances['date_fetched_string'])}", :color => 'white')
                        column("#{getTimeAgoInHumanReadable(balances['date_fetched_string'])}", :color => 'yellow')
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n\n"
    end

    # Display Summary
    def displaySummary
        puts "#{Rainbow(' SUMMARY ').background('#ff008a')}\n\n"

        # Cash Deposited
        cashDep1, cashDep2, cashDep3, cashDep4, cashDep5, cashDepTotal = runCalculationFor(method(:calculateCashDeposited))
        # Rec. IN Received
        inReceived1, inReceived2, inReceived3, inReceived4, inReceived5, inReceivedTotal = runCalculationFor(method(:calculateRecurringInReceived))
        # Rec. IN Outstanding
        inOutstanding1, inOutstanding2, inOutstanding3, inOutstanding4, inOutstanding5, inOutstandingTotal = runCalculationFor(method(:calculateRecurringInOutstanding), Array[inReceived1, inReceived2, inReceived3, inReceived4, inReceived5, inReceivedTotal])
        # Rec. OUT Paid
        outPaid1, outPaid2, outPaid3, outPaid4, outPaid5, outPaidTotal = runCalculationFor(method(:calculateRecurringOutPaid))
        # Rec. Out Outstanding
        outOutstanding1, outOutstanding2, outOutstanding3, outOutstanding4, outOutstanding5, outOutstandingTotal = runCalculationFor(method(:calculateRecurringOutOutstanding), Array[outPaid1, outPaid2, outPaid3, outPaid4, outPaid5, outPaidTotal])

        @rightHandSideContent = Array[
            Array['Credit Score', 'white'],
            Array['989', 'cyan'],
            Array['Total Credit', 'white'],
            Array[getAsCurrency(@totalCredit)[0], 'cyan'],
            Array['Credit Used', 'white'],
            Array[getAsCurrency(0 - @totalCreditUsed)[0], (@totalCreditUsed > 0) ? 'red' : 'cyan'],
        ]

        table(:border => false) do
            row do
                column('', :width => @summaryWidth_1, :align => 'left', :bold => 'true')
                column("#{@month1.strftime('%B %Y')}", :width => @summaryWidth_2, :align => 'right')
                column("#{@month2.strftime('%B %Y')}", :width => @summaryWidth_3, :align => 'right')
                column("#{@month3.strftime('%B %Y')}", :width => @summaryWidth_4, :align => 'right')
                column("#{@month4.strftime('%B %Y')}", :width => @summaryWidth_5, :align => 'right')
                column("#{@month5.strftime('%B %Y')}", :width => @summaryWidth_6, :align => 'right')
                column('Total', :width => @summaryWidth_7, :align => 'right')
                column('', :width => @summaryWidth_8, :align => 'left')
                column('', :width => @summaryWidth_9, :align => 'right')
            end
            row do
                column(getRuleString(@summaryWidth_1))
                column(getRuleString(@summaryWidth_2))
                column(getRuleString(@summaryWidth_3))
                column(getRuleString(@summaryWidth_4))
                column(getRuleString(@summaryWidth_5))
                column(getRuleString(@summaryWidth_6))
                column(getRuleString(@summaryWidth_7))
                column(getRuleString(@summaryWidth_8))
                column(getRuleString(@summaryWidth_9))
            end
            row do
                column(' Current Net Worth')
                column(getAsCurrency(@totalCash)[0], :color => getAsCurrency(@totalCash)[1])
                column('')
                column('')
                column('')
                column('')
                column('')
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Projected (EOM) Balance', :color => 'white')
                column('')
                column('—')
                column('—')
                column('—')
                column('—')
                column('')
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(getRuleString(@summaryWidth_1))
                column(getRuleString(@summaryWidth_2))
                column(getRuleString(@summaryWidth_3))
                column(getRuleString(@summaryWidth_4))
                column(getRuleString(@summaryWidth_5))
                column(getRuleString(@summaryWidth_6))
                column(getRuleString(@summaryWidth_7))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column('')
                column('')
                column('')
                column('')
                column('')
                column('')
                column('')
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Cash Deposited', :color => 'green')
                column("#{(cashDep1[0] <= 0 ? '—' : cashDep1[1][0])}", :color => (cashDep1[0] <= 0 ? 'white' : 'green'))
                column("#{(cashDep2[0] <= 0 ? '—' : cashDep2[1][0])}", :color => (cashDep2[0] <= 0 ? 'white' : 'green'))
                column("#{(cashDep3[0] <= 0 ? '—' : cashDep3[1][0])}", :color => (cashDep3[0] <= 0 ? 'white' : 'green'))
                column("#{(cashDep4[0] <= 0 ? '—' : cashDep4[1][0])}", :color => (cashDep4[0] <= 0 ? 'white' : 'green'))
                column("#{(cashDep5[0] <= 0 ? '—' : cashDep5[1][0])}", :color => (cashDep5[0] <= 0 ? 'white' : 'green'))
                column("#{(cashDepTotal[0] <= 0 ? '—' : cashDepTotal[1][0])}", :color => (cashDepTotal[0] <= 0 ? 'white' : 'green'))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Rec. IN Outstanding', :color => 'cyan')
                column("#{(inOutstanding1[0] <= 0 ? '—' : inOutstanding1[1][0])}", :color => (inOutstanding1[0] <= 0 ? 'white' : 'white'))
                column("#{(inOutstanding2[0] <= 0 ? '—' : inOutstanding2[1][0])}", :color => (inOutstanding2[0] <= 0 ? 'white' : 'white'))
                column("#{(inOutstanding3[0] <= 0 ? '—' : inOutstanding3[1][0])}", :color => (inOutstanding3[0] <= 0 ? 'white' : 'white'))
                column("#{(inOutstanding4[0] <= 0 ? '—' : inOutstanding4[1][0])}", :color => (inOutstanding4[0] <= 0 ? 'white' : 'white'))
                column("#{(inOutstanding5[0] <= 0 ? '—' : inOutstanding5[1][0])}", :color => (inOutstanding5[0] <= 0 ? 'white' : 'white'))
                column("#{(inOutstandingTotal[0] <= 0 ? '—' : inOutstandingTotal[1][0])}", :color => (inOutstandingTotal[0] <= 0 ? 'white' : 'white'))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Rec. IN Received', :color => 'cyan')

                column("#{(inReceived1[0] <= 0 ? '—' : inReceived1[1][0])}", :color => (inReceived1[0] <= 0 ? 'white' : 'white'))
                column("#{(inReceived2[0] <= 0 ? '—' : inReceived2[1][0])}", :color => (inReceived2[0] <= 0 ? 'white' : 'white'))
                column("#{(inReceived3[0] <= 0 ? '—' : inReceived3[1][0])}", :color => (inReceived3[0] <= 0 ? 'white' : 'white'))
                column("#{(inReceived4[0] <= 0 ? '—' : inReceived4[1][0])}", :color => (inReceived4[0] <= 0 ? 'white' : 'white'))
                column("#{(inReceived5[0] <= 0 ? '—' : inReceived5[1][0])}", :color => (inReceived5[0] <= 0 ? 'white' : 'white'))
                column("#{(inReceivedTotal[0] <= 0 ? '—' : inReceivedTotal[1][0])}", :color => (inReceivedTotal[0] <= 0 ? 'white' : 'white'))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Rec. OUT Outstanding', :color => 'red')
                column("#{(outOutstanding1[0] <= 0 ? '—' : outOutstanding1[1][0])}", :color => (outOutstanding1[0] <= 0 ? 'white' : 'white'))
                column("#{(outOutstanding2[0] <= 0 ? '—' : outOutstanding2[1][0])}", :color => (outOutstanding2[0] <= 0 ? 'white' : 'white'))
                column("#{(outOutstanding3[0] <= 0 ? '—' : outOutstanding3[1][0])}", :color => (outOutstanding3[0] <= 0 ? 'white' : 'white'))
                column("#{(outOutstanding4[0] <= 0 ? '—' : outOutstanding4[1][0])}", :color => (outOutstanding4[0] <= 0 ? 'white' : 'white'))
                column("#{(outOutstanding5[0] <= 0 ? '—' : outOutstanding5[1][0])}", :color => (outOutstanding5[0] <= 0 ? 'white' : 'white'))
                column("#{(outOutstandingTotal[0] <= 0 ? '—' : outOutstandingTotal[1][0])}", :color => (outOutstandingTotal[0] <= 0 ? 'white' : 'white'))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Rec. OUT Paid', :color => 'red')
                column("#{(outPaid1[0] <= 0 ? '—' : outPaid1[1][0])}", :color => (outPaid1[0] <= 0 ? 'white' : 'white'))
                column("#{(outPaid2[0] <= 0 ? '—' : outPaid2[1][0])}", :color => (outPaid2[0] <= 0 ? 'white' : 'white'))
                column("#{(outPaid3[0] <= 0 ? '—' : outPaid3[1][0])}", :color => (outPaid3[0] <= 0 ? 'white' : 'white'))
                column("#{(outPaid4[0] <= 0 ? '—' : outPaid4[1][0])}", :color => (outPaid4[0] <= 0 ? 'white' : 'white'))
                column("#{(outPaid5[0] <= 0 ? '—' : outPaid5[1][0])}", :color => (outPaid5[0] <= 0 ? 'white' : 'white'))
                column("#{(outPaidTotal[0] <= 0 ? '—' : outPaidTotal[1][0])}", :color => (outPaidTotal[0] <= 0 ? 'white' : 'white'))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(getRuleString(@summaryWidth_1))
                column(getRuleString(@summaryWidth_2))
                column(getRuleString(@summaryWidth_3))
                column(getRuleString(@summaryWidth_4))
                column(getRuleString(@summaryWidth_5))
                column(getRuleString(@summaryWidth_6))
                column(getRuleString(@summaryWidth_7))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            @recognizedTransactions.each do |recognizedTransaction|
                if recognizedTransaction[:intTypeID] == 3

                    # Rec. IN Received
                    amt1, amt2, amt3, amt4, amt5, amtTotal = runCalculationFor(method(:calculateAmountPaidReceivedForRecognizedTransaction), recognizedTransaction[:id])

                    row do
                        column(" #{recognizedTransaction[:translation][0..23]}", :color => 'white')
                        column("#{(amt1[0] <= 0 ? '—' : amt1[1][0])}", :color => (amt1[0] <= 0 ? 'white' : 'white'))
                        column("#{(amt2[0] <= 0 ? '—' : amt2[1][0])}", :color => (amt2[0] <= 0 ? 'white' : 'white'))
                        column("#{(amt3[0] <= 0 ? '—' : amt3[1][0])}", :color => (amt3[0] <= 0 ? 'white' : 'white'))
                        column("#{(amt4[0] <= 0 ? '—' : amt4[1][0])}", :color => (amt4[0] <= 0 ? 'white' : 'white'))
                        column("#{(amt5[0] <= 0 ? '—' : amt5[1][0])}", :color => (amt5[0] <= 0 ? 'white' : 'white'))
                        column("#{(amtTotal[0] <= 0 ? '—' : amtTotal[1][0])}", :color => (amtTotal[0] <= 0 ? 'white' : 'white'))
                        column(' |')
                        column('')
                    end
                end
            end
            row do
                column(getRuleString(@summaryWidth_1))
                column(getRuleString(@summaryWidth_2))
                column(getRuleString(@summaryWidth_3))
                column(getRuleString(@summaryWidth_4))
                column(getRuleString(@summaryWidth_5))
                column(getRuleString(@summaryWidth_6))
                column(getRuleString(@summaryWidth_7))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' Total IN', :color => 'white')
                column('')
                column('—')
                column('—')
                column('—')
                column('—')
                column('')
                column(' |')
                column('')
            end
            row do
                column(' Total OUT', :color => 'white')
                column('')
                column('—')
                column('—')
                column('—')
                column('—')
                column('')
                column(' |')
                column('')
            end
            row do
                column(' Profit/Loss', :color => 'white')
                column('')
                column('—')
                column('—')
                column('—')
                column('—')
                column('')
                column(' |')
                column('')
            end
            row do
                column(getRuleString(@summaryWidth_1))
                column(getRuleString(@summaryWidth_2))
                column(getRuleString(@summaryWidth_3))
                column(getRuleString(@summaryWidth_4))
                column(getRuleString(@summaryWidth_5))
                column(getRuleString(@summaryWidth_6))
                column(getRuleString(@summaryWidth_7))
                column(' |')
                column('')
            end
        end
        puts "#{getRuleString(@summaryWidthTotal)}\n\n"
    end

    # @return array
    def insertRightHandContent
        @rightHandSideCount = @rightHandSideCount + 1
        if @rightHandSideCount == 3
            @rightHandSideContentCount = @rightHandSideContentCount + 1
        elsif @rightHandSideCount >= 7
            @rightHandSideCount = 1
            @rightHandSideContentCount = @rightHandSideContentCount + 1
        elsif @rightHandSideCount >= 5
            return Array['', 'white']
        end
        content = ''
        color = 'white'
        unless @rightHandSideContent[@rightHandSideContentCount].nil?
            content = @rightHandSideContent[@rightHandSideContentCount][0]
            color = @rightHandSideContent[@rightHandSideContentCount][1]
        end
        Array[content, color.to_s]
    end

    # @return array
    def calculateAmountPaidReceivedForRecognizedTransaction(month, id)
        amt = 0
        @transactions.each do |transaction|
            # IF MONTH IS CURRENT
            if DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%Y%-m') == month.strftime('%Y%-m')
                recognizedTransaction = @recognizedTransactionsIndexedID[id.to_s]
                # IF TRANSACTION IS MATCHED
                if transaction['bank_account_id'].to_i == recognizedTransaction[:bank_account_id] && transaction['type'] == recognizedTransaction[:type] && recognizedTransaction[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                    if recognizedTransaction[:intTypeID] == 2
                        amt = amt + transaction['paid_in'].to_f
                    elsif recognizedTransaction[:intTypeID] == 3
                        amt = amt + transaction['paid_out'].to_f
                    else
                        raise(RunTimeError('ID is not recognized.'))
                    end
                end
            end
        end
        amt
    end

    # @return array
    def runCalculationFor(callback, param1 = nil)
        var1 = Array.new
        var2 = Array.new
        var3 = Array.new
        var4 = Array.new
        var5 = Array.new
        var1[0] = callback.call(@month1, param1)
        var1[1] = getAsCurrency(var1[0])
        var2[0] = callback.call(@month2, param1)
        var2[1] = getAsCurrency(var2[0])
        var3[0] = callback.call(@month3, param1)
        var3[1] = getAsCurrency(var3[0])
        var4[0] = callback.call(@month4, param1)
        var4[1] = getAsCurrency(var4[0])
        var5[0] = callback.call(@month5, param1)
        var5[1] = getAsCurrency(var5[0])
        varTotal = Array.new
        varTotal[0] = var1[0] + var2[0] + var3[0] + var4[0] + var5[0]
        varTotal[1] = getAsCurrency(varTotal[0])
        Array[var1, var2, var3, var4, var5, varTotal]
    end

    # CASH DEPOSITED
    # @return float
    def calculateCashDeposited(month, param1 = nil)
        param1
        total = 0
        @transactions.each do |transaction|
            if DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%m') == month.strftime('%m')
                @recognizedTransactions.each do |recognizedTransaction|
                    if transaction['bank_account_id'].to_i == recognizedTransaction[:bank_account_id] && transaction['type'] == recognizedTransaction[:type] && recognizedTransaction[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                        if recognizedTransaction[:intTypeID] == 1
                            total = total + transaction['paid_in'].to_f
                        end
                    end
                end
            end
        end
        total
    end

    # REC. IN OUTSTANDING
    # @return float
    def calculateRecurringInOutstanding(month, param1 = nil)
        calculateRecurringOutstanding(month, param1, 2)
    end

    # REC. IN RECEIVED
    # @return float
    def calculateRecurringInReceived(month, param1 = nil)
        param1
        total = 0
        @transactions.each do |transaction|
            if DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%m') == month.strftime('%m')
                @recognizedTransactions.each do |recognizedTransaction|
                    if transaction['bank_account_id'].to_i == recognizedTransaction[:bank_account_id] && transaction['type'] == recognizedTransaction[:type] && recognizedTransaction[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                        if recognizedTransaction[:intTypeID] == 2
                            total = total + transaction['paid_in'].to_f
                        end
                    end
                end
            end
        end
        total
    end

    # REC. OUT OUTSTANDING
    # @return float
    def calculateRecurringOutOutstanding(month, param1 = nil)
        calculateRecurringOutstanding(month, param1, 3)
    end

    # REC. OUT PAID
    # @return float
    def calculateRecurringOutPaid(month, param1 = nil)
        param1
        total = 0
        @transactions.each do |transaction|
            if DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%m') == month.strftime('%m')
                @recognizedTransactions.each do |recognizedTransaction|
                    if transaction['bank_account_id'].to_i == recognizedTransaction[:bank_account_id] && transaction['type'] == recognizedTransaction[:type] && recognizedTransaction[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                        if recognizedTransaction[:intTypeID] == 3
                            total = total + transaction['paid_out'].to_f
                        end
                    end
                end
            end
        end
        total
    end

    # REC. OUTSTANDING (COMMON)
    # @return float
    def calculateRecurringOutstanding(month, alreadyPaid, intTypeId)
        total = 0
        @recognizedTransactions.each do |recognizedTransaction|
            if recognizedTransaction[:intTypeID] == intTypeId

                # Check Start Month
                unless recognizedTransaction[:start_month].nil?
                    currentMonth = DateTime.strptime(month.strftime('%Y-%m'), '%Y-%m')
                    startMonth = DateTime.strptime(recognizedTransaction[:start_month], '%Y-%m')
                    if currentMonth < startMonth
                        next

                    end
                end

                total = total + recognizedTransaction[:recurring_amount]
            end
        end
        case month.strftime('%m')
            when @month1.strftime('%m')
                total = total - alreadyPaid[0][0].to_f
            when @month2.strftime('%m')
                total = total - alreadyPaid[1][0].to_f
            when @month3.strftime('%m')
                total = total - alreadyPaid[2][0].to_f
            when @month4.strftime('%m')
                total = total - alreadyPaid[3][0].to_f
            when @month5.strftime('%m')
                total = total - alreadyPaid[4][0].to_f
            else
                raise(RunTimeError('Month not found.'))
        end
        total
    end

    # Get all the totals
    # @return void
    def getTotals
        @totalAvailable =
            (@bankAccountBalances[1]['balance_available'].to_f +
                @bankAccountBalances[2]['balance_available'].to_f +
                @bankAccountBalances[4]['balance_available'].to_f +
                @bankAccountBalances[5]['balance_available'].to_f +
                @bankAccountBalances[7]['balance_available'].to_f +
                @bankAccountBalances[8]['balance_available'].to_f +
                @bankAccountBalances[9]['balance_available'].to_f +
                @bankAccountBalances[10]['balance_available'].to_f).round(2)

        @totalCreditUsed =
            (@bankAccountBalances[7]['balance'].to_f +
                @bankAccountBalances[7]['pending_transactions'].to_f +
                @bankAccountBalances[10]['balance'].to_f +
                @bankAccountBalances[10]['pending_transactions'].to_f +
                @bankAccountBalances[9]['balance'].to_f +
                @bankAccountBalances[9]['pending_transactions'].to_f +
                (@bankAccountBalances[1]['balance'].to_f < 0 ? -@bankAccountBalances[1]['balance'].to_f : 0) +
                (@bankAccountBalances[2]['balance'].to_f < 0 ? -@bankAccountBalances[2]['balance'].to_f : 0) +
                (@bankAccountBalances[3]['balance'].to_f < 0 ? -@bankAccountBalances[3]['balance'].to_f : 0) +
                (@bankAccountBalances[4]['balance'].to_f < 0 ? -@bankAccountBalances[4]['balance'].to_f : 0) +
                (@bankAccountBalances[5]['balance'].to_f < 0 ? -@bankAccountBalances[5]['balance'].to_f : 0) +
                (@bankAccountBalances[8]['balance'].to_f < 0 ? -@bankAccountBalances[8]['balance'].to_f : 0)).round(2)

        @totalCredit =
            (@bankAccountBalances[1]['balance_overdraft'].to_f +
                @bankAccountBalances[2]['balance_overdraft'].to_f +
                @bankAccountBalances[3]['balance_overdraft'].to_f +
                @bankAccountBalances[4]['balance_overdraft'].to_f +
                @bankAccountBalances[5]['balance_overdraft'].to_f +
                @bankAccountBalances[8]['balance_overdraft'].to_f +
                @bankAccountBalances[7]['balance_limit'].to_f +
                @bankAccountBalances[9]['balance_limit'].to_f +
                @bankAccountBalances[10]['balance_limit'].to_f).round(2)

        @totalCash = (@totalAvailable - @totalCredit).round(2)
    end

    # Get summary data for 5 month output
    # @return void
    def getSummaryData
        month1String = @month1.strftime('%Y-%m')
        month2String = @month2.strftime('%Y-%m')
        month3String = @month3.strftime('%Y-%m')
        month4String = @month4.strftime('%Y-%m')
        month5String = @month5.strftime('%Y-%m')

        @transactions.each do |transaction|

            # Find out what month we're in and retrieve relevant location in memory for object.
            transactionMonth = DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%Y-%m')
            case transactionMonth
                when month1String
                    monthObject = @summaryData[:month1]
                when month2String
                    monthObject = @summaryData[:month2]
                when month3String
                    monthObject = @summaryData[:month3]
                when month4String
                    monthObject = @summaryData[:month4]
                when month5String
                    monthObject = @summaryData[:month5]
                else
                    raise(RuntimeError, "Month [#{transactionMonth}] not recognized.")
            end

            transactionRecognized = false
            transactionAdded = false

            # Check if transaction is recognized.
            @recognizedTransactions.each do |rt|
                if transaction['bank_account_id'].to_i == rt[:bank_account_id] && transaction['type'] == rt[:type] && rt[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                    transactionRecognized = rt[:id]
                    break
                end
            end

            # Process recurring transactions
            if transactionRecognized
                transactionAdded = true
                rt = @recognizedTransactionsIndexedID["#{transactionRecognized}"]
                if rt[:intTypeID] == 1
                    monthObject[:cash_in] = monthObject[:cash_in] + transaction['paid_in'].to_f
                elsif rt[:intTypeID] == 2
                    if monthObject[:"#{rt[:id]}"].nil?
                        monthObject[:"#{rt[:id]}"] = 0
                    end
                    monthObject[:"#{rt[:id]}"] = monthObject[:"#{rt[:id]}"] + transaction['paid_in'].to_f
                elsif rt[:intTypeID] == 3
                    if monthObject[:"#{rt[:id]}"].nil?
                        monthObject[:"#{rt[:id]}"] = 0
                    end
                    monthObject[:"#{rt[:id]}"] = monthObject[:"#{rt[:id]}"] + transaction['paid_out'].to_f
                else
                    transactionAdded = false
                end
            end

            # Process remaining transactions (un-recurring)
            if transactionAdded
                if transaction['paid_in'].to_f > 0
                    monthObject[:misc_in] = monthObject[:misc_in] + transaction['paid_in'].to_f
                elsif transaction['paid_out'].to_f > 0
                    monthObject[:misc_out] = monthObject[:misc_out] + transaction['paid_out'].to_f
                end
            end

            # Calculate Totals (for all transactions)
            if transaction['paid_in'].to_f > 0
                monthObject[:total_in] = monthObject[:total_in] + transaction['paid_in'].to_f
            elsif transaction['paid_out'].to_f > 0
                monthObject[:total_out] = monthObject[:total_out] + transaction['paid_out'].to_f
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