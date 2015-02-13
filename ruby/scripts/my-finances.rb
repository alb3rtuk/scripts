require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'

require 'columnist'

class ShowBankTransactions

    include Columnist

    # Initialize all the DB stuff, etc.
    def initialize(argv)

        # COLORS
        @green = 10
        @magenta = 201
        @yellow = 226
        @cyan = 87
        @red = 9
        @blue = 32
        @white = 255

        @plus_color = 47
        @minus_color = 196

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
            {:intTypeID => 0, :id => 100, :bank_account_id => 1, :type => 'BAC', :terms => Array['PAYPAL', 'PPWD'], :color => @white, :translation => 'PAYPAL WITHDRAWAL'},
            {:intTypeID => 1, :id => 200, :bank_account_id => 1, :type => 'CDM', :terms => Array['521005', '521007', '560005'], :color => @green, :translation => 'CASH'},
            {:intTypeID => 1, :id => 200, :bank_account_id => 1, :type => '-  ', :terms => Array['521005', '521007', '560005'], :color => @green, :translation => 'CASH'},
            {:intTypeID => 1, :id => 200, :bank_account_id => 1, :type => 'TLR', :terms => Array[''], :color => @green, :translation => 'CASH'},
            {:intTypeID => 3, :id => 300, :bank_account_id => 1, :type => 'POS', :terms => Array['NAMESCO'], :color => @red, :translation => 'NAMESCO WEB SERVER', :recurring_amount => 29.99},
            {:intTypeID => 3, :id => 400, :bank_account_id => 1, :type => 'D/D', :terms => Array['SLMLTD INCOME AC'], :color => @red, :translation => 'HORFIELD SPORTS CENTRE', :recurring_amount => 33.60},
            {:intTypeID => 0, :id => 500, :bank_account_id => 1, :type => 'D/D', :terms => Array['UK MAIL'], :color => @white, :translation => 'UK MAIL'},
            {:intTypeID => 0, :id => 600, :bank_account_id => 1, :type => 'POS', :terms => Array['UK MAIL'], :color => @white, :translation => 'UK MAIL'},
            {:intTypeID => 0, :id => 700, :bank_account_id => 1, :type => 'OTR', :terms => Array['07519616416'], :color => @white, :translation => 'ROSS JOY'},
            {:intTypeID => 0, :id => 800, :bank_account_id => 1, :type => 'OTR', :terms => Array['07980286590', 'SCOULDING L A'], :color => @white, :translation => 'LUKE SCOULDING'},
            {:intTypeID => 0, :id => 900, :bank_account_id => 1, :type => 'OTR', :terms => Array['07825126363'], :color => @white, :translation => 'LUKE CHAMBERLAIN'},
            {:intTypeID => 0, :id => 1000, :bank_account_id => 1, :type => 'BAC', :terms => Array['D LINDEN'], :color => @white, :translation => 'DEAN LINDEN'},
            {:intTypeID => 0, :id => 1100, :bank_account_id => 1, :type => 'BAC', :terms => Array['P HACKETT'], :color => @white, :translation => 'PHIL HACKETT'},
            {:intTypeID => 2, :id => 1150, :bank_account_id => 1, :type => 'BAC', :terms => Array['SALARY','T27 SYSTEMS'], :color => @cyan, :translation => 'BRIGHTPEARL WAGE', :recurring_amount => 1946.23}, # 1946.23
            {:intTypeID => 2, :id => 1200, :bank_account_id => 1, :type => 'BAC', :terms => Array['VIRGIN TV'], :color => @cyan, :translation => 'GARY SOLAN (VIRGIN MEDIA)', :recurring_amount => 30},
            {:intTypeID => 0, :id => 1400, :bank_account_id => 1, :type => 'BAC', :terms => Array['ALEX CARLIN'], :color => @white, :translation => 'ALEX CARLIN'},
            {:intTypeID => 0, :id => 1500, :bank_account_id => 1, :type => 'BAC', :terms => Array['J HARTRY '], :color => @white, :translation => 'JOE HARTRY'},
            {:intTypeID => 3, :id => 1600, :bank_account_id => 1, :type => 'POS', :terms => Array['SPOTIFY'], :color => @red, :translation => 'SPOTIFY', :recurring_amount => 19.98},
            {:intTypeID => 3, :id => 1700, :bank_account_id => 1, :type => 'POS', :terms => Array['LYNDA.COM'], :color => @red, :translation => 'LYNDA.COM', :recurring_amount => 16, :estimated => true},
            {:intTypeID => 3, :id => 1800, :bank_account_id => 1, :type => 'POS', :terms => Array['GITHUB.COM'], :color => @red, :translation => 'GITHUB.COM', :recurring_amount => 8.50, :estimated => true},
            {:intTypeID => 0, :id => 1900, :bank_account_id => 1, :type => 'POS', :terms => Array['TRANSFERWISE'], :color => @white, :translation => 'TRANFERWISE (WEDDING FUND)'},
            # NATWEST SAVINGS
            {:intTypeID => 0, :id => 2000, :bank_account_id => 3, :type => 'BAC', :terms => Array['TRANSFERWISE'], :color => @white, :translation => 'TRANFERWISE (REFUND)'},
            # HALIFAX ULTIMATE REWARD
            {:intTypeID => 3, :id => 2100, :bank_account_id => 4, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => @red, :translation => 'ACCOUNT FEE (HALIFAX ULTIAMTE REWARD)', :recurring_amount => 15},
            {:intTypeID => 1, :id => 2200, :bank_account_id => 4, :type => 'CSH', :terms => Array[''], :color => @green, :translation => 'CASH'},
            {:intTypeID => 3, :id => 2250, :bank_account_id => 4, :type => 'DD', :terms => Array['DVLA-EU51GVC'], :color => @red, :translation => 'CAR TAX (DVLA-EU51GVC)', :recurring_amount => 19.68},
            # HALIFAX REWARD
            {:intTypeID => 3, :id => 2300, :bank_account_id => 5, :type => 'DEB', :terms => Array['CREDITEXPERT.CO.UK'], :color => @red, :translation => 'CREDITEXPERT', :recurring_amount => 9.99},
            {:intTypeID => 3, :id => 2350, :bank_account_id => 5, :type => 'DEB', :terms => Array['ANIMOTO'], :color => @red, :translation => 'ANIMOTO', :recurring_amount => 5},
            {:intTypeID => 0, :id => 2400, :bank_account_id => 5, :type => 'FPI', :terms => Array['PAYPAL WITHDRAWAL'], :color => @white, :translation => 'PAYPAL WITHDRAWAL'},
            {:intTypeID => 1, :id => 2500, :bank_account_id => 5, :type => 'CSH', :terms => Array[''], :color => @green, :translation => 'CASH'},
            {:intTypeID => 0, :id => 2550, :bank_account_id => 6, :type => 'D-C', :terms => Array[''], :color => @white, :translation => 'ISA INTEREST'},
            # LLOYDS CURRENT
            {:intTypeID => 3, :id => 2600, :bank_account_id => 8, :type => 'FPO', :terms => Array['STELLA TALIOTIS'], :color => @red, :translation => 'RENT', :recurring_amount => 250},
            {:intTypeID => 3, :id => 2700, :bank_account_id => 8, :type => 'DD', :terms => Array['VODAFONE LIMITED'], :color => @red, :translation => 'VODAFONE LIMITED', :recurring_amount => 60, :estimated => true},
            {:intTypeID => 3, :id => 2800, :bank_account_id => 8, :type => 'DD', :terms => Array['VIRGIN MEDIA'], :color => @red, :translation => 'VIRGIN MEDIA', :recurring_amount => 112.99, :estimated => true},
            {:intTypeID => 1, :id => 2900, :bank_account_id => 8, :type => 'CSH', :terms => Array[''], :color => @green, :translation => 'CASH'},
            {:intTypeID => 1, :id => 2950, :bank_account_id => 8, :type => 'DEP', :terms => Array[''], :color => @green, :translation => 'CASH'},
            {:intTypeID => 3, :id => 3000, :bank_account_id => 8, :type => 'DD', :terms => Array['TESCO BANK'], :color => @red, :translation => 'TESCO CAR INSURANCE', :recurring_amount => 62.73},
            {:intTypeID => 3, :id => 3100, :bank_account_id => 8, :type => 'FEE', :terms => Array['ACCOUNT FEE'], :color => @red, :translation => 'ACCOUNT FEE (LLOYDS CURRENT)', :recurring_amount => 15},
            {:intTypeID => 2, :id => 3200, :bank_account_id => 8, :type => 'FPI', :terms => Array['MATTHEW JONES'], :color => @cyan, :translation => 'MATT JONES (VIRGIN MEDIA)', :recurring_amount => 24},
        ]

        @recognizedTransactionsIndexedID = {}
        @recognizedTransactions.each do |recognizedTransaction|
            @recognizedTransactionsIndexedID["#{recognizedTransaction[:id]}"] = recognizedTransaction
        end

        @internalTransfers = Array[
            # NATWEST
            {:bank_account_id => Array[1, 2, 3], :type => 'BAC', :terms => Array['A RANNETSPERGER', 'HALIFAX ULTIMATE', 'HALIFAX REWARD', 'AR HALIFAX ACC', 'LLOYDS ACCOUNT']},
            {:bank_account_id => Array[1, 2, 3], :type => 'OTR', :terms => Array['CALL REF.NO.'], :terms_not => ['UK MAIL LIMITED', 'DEAN LINDEN', 'TRANSFERWISE']},
            {:bank_account_id => Array[1, 2, 3], :type => 'POS', :terms => Array['BARCLAYCARD', 'CAPITAL ONE']},
            # LLOYDS
            {:bank_account_id => Array[8], :type => 'FPO', :terms => Array['NATWEST AD GOLD', 'NATWEST STEP', 'NATWEST SAVINGS', 'LLOYDS BANK PLATIN']},
            {:bank_account_id => Array[8], :type => 'FPI', :terms => Array['RANNETSPERGER A NATWEST']},
            {:bank_account_id => Array[8], :type => 'TFR', :terms => Array['HALIFAX ULTIMATE', 'HALIFAX REWARD', 'A RANNETSPERGER']},
            {:bank_account_id => Array[7], :type => 'CC', :terms => Array['PAYMENT RECEIVED']},
            # HALIFAX
            {:bank_account_id => Array[4, 5], :type => 'DEB', :terms => Array['BARCLAYCARD']},
            {:bank_account_id => Array[4, 5], :type => 'FPO', :terms => Array['NATWEST']},
            {:bank_account_id => Array[4, 5], :type => 'FPI', :terms => Array['RANNETSPERGER A NATWEST']},
            {:bank_account_id => Array[4, 5], :type => 'TFR', :terms => Array['HALIFAX ULTIMATE', 'HALIFAX REWARD', 'A RANNETSPERGER']},
            {:bank_account_id => Array[6], :type => 'P-C', :terms => Array['']},
            {:bank_account_id => Array[6], :type => 'P-T', :terms => Array['']},
            {:bank_account_id => Array[6], :type => 'D-T', :terms => Array['']},
            # BARCLAYCARD
            {:bank_account_id => Array[9], :type => 'OTHER', :terms => Array['PAYMENT, THANK YOU']},
            # CAPITAL ONE
            {:bank_account_id => Array[10], :type => 'CR', :terms => Array['PAYMENT RECEIVED', 'DIRECT DEBIT PAYMENT']},
        ]

        @ignoredTransactions = Array.new

        # Hawaii Payments
        @ignoredTransactions.push(*Array[2556, 2557, 2558, 2555, 2545, 2567, 2576, 2566, 2959, 3328, 3364, 3310, 3349, 3405, 3413, 3424, 3482, 3483, 3492, 3493, 3543, 3564, 3556, 3585, 3593, 3599, 3600, 3615, 3619, 3635, 3672, 3723, 3789, 3954, 3989])

        # Misc Globals
        @rightHandSideCount = 4
        @rightHandSideContent = Array.new
        @rightHandSideContentCount = -1
        @rightHandSideContentExists = true

        # Balance Globals
        @totalAvailable = 0
        @totalCredit = 0
        @totalCreditUsed = 0
        @totalCash = 0
        @moneyInRemaining = 0
        @moneyOutRemaining = 0
        @fixedMonthlyOutgoings = 0
        @creditScore = Array.new

        @summaryData = {
            :month1 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0, :starting_balances => 0},
            :month2 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0, :starting_balances => 0},
            :month3 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0, :starting_balances => 0},
            :month4 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0, :starting_balances => 0},
            :month5 => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0, :starting_balances => 0},
            :monthTotal => {:misc_in => 0, :misc_out => 0, :cash_in => 0, :total_in => 0, :total_out => 0, :profit_loss => 0},
        }

        # Months
        @month1 = DateTime.now
        @month2 = DateTime.now << 1
        @month3 = DateTime.now << 2
        @month4 = DateTime.now << 3
        @month5 = DateTime.now << 4

        # Get different modes.
        @untranslated = false
        @withIDs = false
        @withInternalTransfers = false
        if argv == 'untranslated'
            @untranslated = true
        elsif argv == 'with-ids'
            @withIDs = true
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
                    bankAccountTable = 'bank_account_type_isa'
                else
                    raise(RuntimeError, "bank_account_type => #{bankAccount['bank_account_type']} doesn't exist.")
            end
            balance = @databaseConnection.query("SELECT * FROM #{bankAccountTable} WHERE bank_account_id='#{bankAccount['id']}' ORDER BY date_fetched DESC LIMIT 1")
            @bankAccountBalances[bankAccount['id'].to_i] = balance.fetch_hash
            balance.free
        end

        # Get transactions into Hash
        @transactions = Array.new
        transactionsSQL = @databaseConnection.query("SELECT * FROM bank_account_transactions WHERE date >= '#{@month5.strftime('%Y-%m-01')}' ORDER BY date ASC, bank_account_id ASC, type ASC")
        transactionsSQL.each_hash do |transaction|

            # Skip ISA.
            if transaction['bank_account_id'].to_i == 6
                next
            end

            @transactions << transaction
        end
        transactionsSQL.free

        # Column widths for transactions
        @transWidth_1 = 20
        @transWidth_2 = 20
        @transWidth_3 = 12
        @transWidth_4 = 111
        @transWidth_5 = 6
        @transWidth_6 = 11
        @transWidth_7 = 12
        @transWidthTotal = @transWidth_1 + @transWidth_2 + @transWidth_3 + @transWidth_4 + @transWidth_5 + @transWidth_6 + @transWidth_7 + 8

        # Column widths for balances
        @colWidth_1 = 20
        @colWidth_2 = 22
        @colWidth_3 = 20
        @colWidth_4 = 20
        @colWidth_5 = 20
        @colWidth_6 = 20
        @colWidth_7 = 20
        @colWidth_8 = 21
        @colWidth_9 = 2
        @colWidth_10 = 24
        @colWidthTotal = @colWidth_1 + @colWidth_2 + @colWidth_3 + @colWidth_4 + @colWidth_5 + @colWidth_6 + @colWidth_7 + @colWidth_8 + @colWidth_9 + @colWidth_10 + 9

        # Column widths for balances
        @summaryWidth_1 = 43
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
        # MAKE SURE WE'RE ONLINE
        checkMachineIsOnline

        # DO ALL CALCULATIONS
        calculateSummary
        calculateMoneyRemaining
        calculateFixedMonthlyOutgoings

        # DO GETS
        getCreditScore
        getTotals

        # START OUTPUT
        displayTransactions
        displayCreditCards
        displayBankAccounts
        displaySummary
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
                column('Type')
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
                        if @ignoredTransactions.include?(transaction['id'].to_i)
                            transactionColor = @green
                        else
                            transactionColor = @yellow
                        end
                    else
                        next
                    end
                else
                    if @withInternalTransfers
                        transactionColor = @white
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

                # Format description
                if @withIDs
                    descriptionAddedInfo = "##{transaction['id']}"
                    description = transactionDescription[0..((@transWidth_4 - 2) - descriptionAddedInfo.length)]
                    description = "#{descriptionAddedInfo}#{getRuleString(@transWidth_4 - (descriptionAddedInfo.length + description.length), ' ')}#{description}"
                else
                    description = transactionDescription[0..(@transWidth_4 - 2)]
                end

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
        puts "\n#{getRuleString(@colWidthTotal)}"
    end

    # Translates Description
    # @return string
    def getDescriptionAndColor(transaction)
        @recognizedTransactions.each do |translation|
            if transaction['bank_account_id'].to_i == translation[:bank_account_id] && transaction['type'] == translation[:type] && translation[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                return {:description => translation[:translation].upcase, :color => translation[:color]}
            end
        end
        {:description => transaction['description'].upcase, :color => @white}
    end

    # Returns TRUE if transaction is internal transfer
    # @return boolean
    def isInternalTransfer(transaction)
        if inArray(@ignoredTransactions, transaction['id'].to_i)
            return true
        end
        @internalTransfers.each do |match|
            if match[:bank_account_id].any? { |w| transaction['bank_account_id'] =~ /#{w}/ } && match[:terms].any? { |w| transaction['description'].upcase =~ /#{w}/ } && match[:type] == transaction['type']
                if match.has_key?(:terms_not)
                    if match[:terms_not].any? { |w| transaction['description'] =~ /#{w}/ }
                        return false
                    end
                end
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
            column(" [ #{month.upcase} ] #{getRuleString(@transWidth_4 - (month.length + 6))}")
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
        table(:border => false) do
            row do
                column(' Bank', :width => @colWidth_1, :align => 'left', :bold => 'true')
                column('Name', :width => @colWidth_2, :align => 'left', :bold => 'true')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Overdraft', :width => @colWidth_5, :align => 'right')
                column('', :width => @colWidth_6, :align => 'right')
                column('', :width => @colWidth_7, :align => 'right')
                column('', :width => @colWidth_8, :align => 'right')
                column(' |', :width => @colWidth_9, :align => 'right')
                column('Last Fetch', :width => @colWidth_10, :align => 'right')
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
                column(getRuleString(@colWidth_10))
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
                        column(getAsCurrency(balances['balance_available'])[0], :color => @white)
                        column(getAsCurrency(balances['balance_overdraft'])[0], :color => @white)
                        column('—', :color => @white)
                        column('—', :color => @white)
                        column('—', :color => @white)
                        column(' |')
                        column("#{getTimeAgoInHumanReadable(balances['date_fetched_string'])}", :color => @white)
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}"
    end

    # Display CreditCards
    def displayCreditCards
        summaryTitle = "\x1B[48;5;92m SUMMARY FOR \xe2\x86\x92 #{DateTime.now.strftime('%^B %e, %Y (%^A)')} \x1B[0m"
        puts '|'.rjust(173, ' ')
        puts "#{summaryTitle.ljust(186, ' ')}|"
        puts '|'.rjust(173, ' ')
        table(:border => false) do
            row do
                column(' Credit Card', :width => @colWidth_1, :align => 'left', :bold => 'true')
                column('Name', :width => @colWidth_2, :align => 'left', :bold => 'true')
                column('Balance', :width => @colWidth_3, :align => 'right')
                column('Available', :width => @colWidth_4, :align => 'right')
                column('Limit', :width => @colWidth_5, :align => 'right')
                column('Pending', :width => @colWidth_6, :align => 'right')
                column('Minimum Payment', :width => @colWidth_7, :align => 'right')
                column('Payment Date', :width => @colWidth_8, :align => 'right')
                column(' |', :width => @colWidth_9, :align => 'left')
                column('Last Fetch', :width => @colWidth_10, :align => 'right')
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
                column(getRuleString(@colWidth_10))
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
                            minimumPaymentColor = @red
                        else
                            minimumPaymentColor = @white
                        end

                        # Calculate Pending Transacions for LLoyds & Capital One.
                        if row['id'].to_i == 7 || row['id'].to_i == 10
                            balances['pending_transactions'] = '%.2f' % (balances['balance_limit'].to_f - balances['balance_available'].to_f - balances['balance'].to_f)
                        end

                        column(getAsCurrency(creditCardBalance)[0], :color => (getAsCurrency(creditCardBalance)[1] == @red) ? @red : @white)
                        column(getAsCurrency(balances['balance_available'])[0], :color => @white)
                        column(getAsCurrency(balances['balance_limit'])[0], :color => @white)
                        column(balances['pending_transactions'].to_f <= 0 ? '—' : getAsCurrency(0 - balances['pending_transactions'].to_f)[0], :color => balances['pending_transactions'].to_f <= 0 ? @white : getAsCurrency(0 - balances['pending_transactions'].to_f)[1])
                        column(getAsCurrency(balances['minimum_payment'])[0], :color => (balances['minimum_payment'].to_f > 0) ? ((minimumPaymentDateIn <= 3) ? @red : @white) : @white)
                        if minimumPaymentDateIn < 0 || balances['minimum_payment'].to_f == 0
                            column('—', :color => @white)
                        else
                            column("#{DateTime.strptime(minimumPaymentDate, '%Y-%m-%d').strftime('%d %b %Y')}", :color => minimumPaymentColor)
                        end
                        column(' |')
                        column("#{getTimeAgoInHumanReadable(balances['date_fetched_string'])}", :color => @white)
                    end
                end
            end
        end
        puts "#{getRuleString(@colWidthTotal)}\n"
    end

    # Display Summary
    def displaySummary
        # Get some info for 'Estimated [XX]' column.
        endOfMonthDate = DateTime.new(@month1.strftime('%Y').to_i, @month1.strftime('%m').to_i, getEndOfMonthDay, 0, 0, 0, 0)
        case endOfMonthDate.strftime('%d').to_i
            when 28..30
                endOfMonthSuffix = 'th'
            when 31
                endOfMonthSuffix = 'st'
            else
                endOfMonthSuffix = ''
        end
        projectedOEMBalance = getProjectedOEMBalance

        @rightHandSideContent = Array[
            Array['Current Balance', @white],
            Array[getAsCurrency(@totalCash)[0], getAsCurrency(@totalCash)[1]],
            Array['After Bills/Wages', @white],
            Array[getBalanceAfterBills.nil? ? '-' : getAsCurrency(getBalanceAfterBills)[0], getBalanceAfterBills.nil? ? @white : getAsCurrency(getBalanceAfterBills)[1]],
            Array["Estimated [#{endOfMonthDate.strftime('%b %d')}#{endOfMonthSuffix}]", @white],
            Array[projectedOEMBalance.nil? ? '—' : getAsCurrency(projectedOEMBalance)[0], projectedOEMBalance.nil? ? @white : getAsCurrency(projectedOEMBalance)[1]],
            Array['NatWest Savings Account', @white],
            Array[getAsCurrency(@bankAccountBalances[3]['balance'])[0], getAsCurrency(@bankAccountBalances[3]['balance'])[1]],
            Array['Credit Total', @white],
            Array[getAsCurrency(@totalCredit)[0], @cyan],
            Array['Credit Used', @white],
            Array["#{calculateCreditUsed}%", @magenta],
            Array['Monthly Outgoings', @white],
            Array[getAsCurrency(@fixedMonthlyOutgoings)[0], @cyan],
            Array['Remaining Outgoings', @white],
            Array["#{@moneyOutRemaining > 0 ? '—' : ''}#{getAsCurrency(@moneyOutRemaining)[0]}", @moneyOutRemaining <= 0 ? @white : @red],
            Array['Remaining Incomings', @white],
            Array["#{getAsCurrency(@moneyInRemaining)[0]}", @moneyInRemaining <= 0 ? @white : @cyan],
            Array['Credit Score', @white],
            Array["#{@creditScore[0]} (#{@creditScore[1]})", @green],
        ]

        table(:border => false) do
            row do
                column('', :width => @summaryWidth_1, :align => 'left')
                column("#{@month1.strftime('%B %Y')}", :width => @summaryWidth_2, :align => 'right', :color => 245)
                column("#{@month2.strftime('%B %Y')}", :width => @summaryWidth_3, :align => 'right', :color => 245)
                column("#{@month3.strftime('%B %Y')}", :width => @summaryWidth_4, :align => 'right', :color => 245)
                column("#{@month4.strftime('%B %Y')}", :width => @summaryWidth_5, :align => 'right', :color => 245)
                column("#{@month5.strftime('%B %Y')}", :width => @summaryWidth_6, :align => 'right', :color => 245)
                column('5-Month Total', :width => @summaryWidth_7, :align => 'right', :color => 245)
                column(' |', :width => @summaryWidth_8, :align => 'left')
                column(insertRightHandContent[0], :color => insertRightHandContent[1], :width => @summaryWidth_9, :align => 'right')
            end
            displaySummaryDivider
            row do
                column(' STARTING BALANCE', :color => @white)
                column("#{@summaryData[:month1][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month1][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month2][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month2][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month3][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month3][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month4][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month4][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month5][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month5][:starting_balances][:totalCash])[0]}", :color => @white)
                column('—', :color => @white)
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            displaySummaryDivider
            row do
                column(' CASH DEPOSITED', :color => @green)
                column("#{@summaryData[:month1][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:month1][:cash_in])[0]}", :color => (@summaryData[:month1][:cash_in].to_f <= 0 ? @white : @green))
                column("#{@summaryData[:month2][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:month2][:cash_in])[0]}", :color => (@summaryData[:month2][:cash_in].to_f <= 0 ? @white : @green))
                column("#{@summaryData[:month3][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:month3][:cash_in])[0]}", :color => (@summaryData[:month3][:cash_in].to_f <= 0 ? @white : @green))
                column("#{@summaryData[:month4][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:month4][:cash_in])[0]}", :color => (@summaryData[:month4][:cash_in].to_f <= 0 ? @white : @green))
                column("#{@summaryData[:month5][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:month5][:cash_in])[0]}", :color => (@summaryData[:month5][:cash_in].to_f <= 0 ? @white : @green))
                column("#{@summaryData[:monthTotal][:cash_in].to_f <= 0 ? '—' : getAsCurrency(@summaryData[:monthTotal][:cash_in])[0]}", :color => (@summaryData[:monthTotal][:cash_in].to_f <= 0 ? @white : @green))
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            displaySummaryDivider
            recognizedTransactionLoop(2)
            # row do
            #     column(' MISC (IN)', :color => @plus_color)
            #     column(@summaryData[:month1][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month1][:misc_in])[0], :color => @summaryData[:month1][:misc_in] <= 0 ? @white : @plus_color)
            #     column(@summaryData[:month2][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month2][:misc_in])[0], :color => @summaryData[:month2][:misc_in] <= 0 ? @white : @plus_color)
            #     column(@summaryData[:month3][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month3][:misc_in])[0], :color => @summaryData[:month3][:misc_in] <= 0 ? @white : @plus_color)
            #     column(@summaryData[:month4][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month4][:misc_in])[0], :color => @summaryData[:month4][:misc_in] <= 0 ? @white : @plus_color)
            #     column(@summaryData[:month5][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month5][:misc_in])[0], :color => @summaryData[:month5][:misc_in] <= 0 ? @white : @plus_color)
            #     column(@summaryData[:monthTotal][:misc_in] <= 0 ? '—' : getAsCurrency(@summaryData[:monthTotal][:misc_in])[0], :color => @summaryData[:monthTotal][:misc_in] <= 0 ? @white : @plus_color)
            #     column(' |')
            #     column(insertRightHandContent[0], :color => insertRightHandContent[1])
            # end
            displaySummaryDivider
            recognizedTransactionLoop(3)
            # row do
            #     column(' MISC (OUT)', :color => @minus_color)
            #     column(@summaryData[:month1][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:month1][:misc_out])[0], :color => @summaryData[:month1][:misc_out] <= 0 ? @white : @minus_color)
            #     column(@summaryData[:month2][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:month2][:misc_out])[0], :color => @summaryData[:month2][:misc_out] <= 0 ? @white : @minus_color)
            #     column(@summaryData[:month3][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:month3][:misc_out])[0], :color => @summaryData[:month3][:misc_out] <= 0 ? @white : @minus_color)
            #     column(@summaryData[:month4][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:month4][:misc_out])[0], :color => @summaryData[:month4][:misc_out] <= 0 ? @white : @minus_color)
            #     column(@summaryData[:month5][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:month5][:misc_out])[0], :color => @summaryData[:month5][:misc_out] <= 0 ? @white : @minus_color)
            #     column(@summaryData[:monthTotal][:misc_out] <= 0 ? '—' : getAsCurrency(@summaryData[:monthTotal][:misc_out])[0], :color => @summaryData[:monthTotal][:misc_out] <= 0 ? @white : @minus_color)
            #     column(' |')
            #     column(insertRightHandContent[0], :color => insertRightHandContent[1])
            # end
            displaySummaryDivider
            row do
                column(' TOTAL MONEY IN', :color => @white)
                column(@summaryData[:month1][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month1][:total_in])[0], :color => @white)
                column(@summaryData[:month2][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month2][:total_in])[0], :color => @white)
                column(@summaryData[:month3][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month3][:total_in])[0], :color => @white)
                column(@summaryData[:month4][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month4][:total_in])[0], :color => @white)
                column(@summaryData[:month5][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:month5][:total_in])[0], :color => @white)
                column(@summaryData[:monthTotal][:total_in] <= 0 ? '—' : getAsCurrency(@summaryData[:monthTotal][:total_in])[0], :color => @white)
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            row do
                column(' TOTAL MONEY OUT', :color => @white)
                column(@summaryData[:month1][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:month1][:total_out])[0], :color => @white)
                column(@summaryData[:month2][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:month2][:total_out])[0], :color => @white)
                column(@summaryData[:month3][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:month3][:total_out])[0], :color => @white)
                column(@summaryData[:month4][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:month4][:total_out])[0], :color => @white)
                column(@summaryData[:month5][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:month5][:total_out])[0], :color => @white)
                column(@summaryData[:monthTotal][:total_out] <= 0 ? '—' : getAsCurrency(0 - @summaryData[:monthTotal][:total_out])[0], :color => @white)
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            displaySummaryDivider
            row do
                column(' ENDING BALANCE', :color => @white)
                column('—', :color => @white)
                column("#{@summaryData[:month1][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month1][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month2][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month2][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month3][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month3][:starting_balances][:totalCash])[0]}", :color => @white)
                column("#{@summaryData[:month4][:starting_balances][:totalCash].nil? ? '—' : getAsCurrency(@summaryData[:month4][:starting_balances][:totalCash])[0]}", :color => @white)
                column('—', :color => @white)
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
            displaySummaryDivider
            row do
                column(' PROFIT/LOSS', :color => @white)
                column(@summaryData[:month1][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:month1][:profit_loss])[0], :color => @summaryData[:month1][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:month1][:profit_loss])[1])
                column(@summaryData[:month2][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:month2][:profit_loss])[0], :color => @summaryData[:month2][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:month2][:profit_loss])[1])
                column(@summaryData[:month3][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:month3][:profit_loss])[0], :color => @summaryData[:month3][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:month3][:profit_loss])[1])
                column(@summaryData[:month4][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:month4][:profit_loss])[0], :color => @summaryData[:month4][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:month4][:profit_loss])[1])
                column(@summaryData[:month5][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:month5][:profit_loss])[0], :color => @summaryData[:month5][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:month5][:profit_loss])[1])
                column(@summaryData[:monthTotal][:profit_loss] == 0 ? '—' : getAsCurrency(@summaryData[:monthTotal][:profit_loss])[0], :color => @summaryData[:monthTotal][:profit_loss] == 0 ? @white : getAsCurrency(@summaryData[:monthTotal][:profit_loss])[1])
                column(' |')
                column(insertRightHandContent[0], :color => insertRightHandContent[1])
            end
        end
        puts "#{getRuleString(@summaryWidthTotal)}"

        # Calculates (displays) where to put arrow depending on how far through the month we are..
        currentDay = @month1.strftime('%d').to_f
        lastDay = (getEndOfMonthDay.to_f) - 1
        percentOfMonthLeft = 100 - (currentDay - 1) / (lastDay / 100)
        pixelsRemaining = ((@summaryWidthTotal - 1).to_f / 100) * percentOfMonthLeft
        pixelToPutArrow = ((@summaryWidthTotal - 1) - pixelsRemaining)
        puts " \x1B[36m#{getRuleString(pixelToPutArrow - 1, ' ')}\x1B[33m\xe2\x98\x85\x1B[0m\n\n"

        # Uncomment for 'Enter to clear' functionality after script run.
        # 31-10-2014 - Removing this because it's annoying.

        # enter_to_clear
    end

    # @return void
    def displaySummaryDivider

        row do
            column(getRuleString(@summaryWidth_1), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_2), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_3), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_4), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_5), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_6), :bold => false, :color => @white)
            column(getRuleString(@summaryWidth_7), :bold => false, :color => @white)
            column(' |', :bold => false, :color => @white)
            column(insertRightHandContent[0], :color => insertRightHandContent[1], :bold => false)
        end
    end

    # @return void
    def recognizedTransactionLoop(intTypeId)
        @recognizedTransactions.each do |recognizedTransaction|
            if recognizedTransaction[:intTypeID] == intTypeId

                amt1, amt2, amt3, amt4, amt5, amtTotal = runCalculationFor(method(:calculateAmountPaidReceivedForRecognizedTransaction), recognizedTransaction[:id])

                plus_color = 235
                minus_color = 235

                if intTypeId == 2
                    color = Array[plus_color, plus_color, plus_color, plus_color, plus_color, plus_color]
                else
                    color = Array[minus_color, minus_color, minus_color, minus_color, minus_color, minus_color]
                end

                # Only do estimations for 1st column (current month)
                if amt1[0] == 0
                    amt1 = Array[23, Array["#{(!recognizedTransaction[:estimated].nil?) ? '~' : ''}#{getAsCurrency(recognizedTransaction[:recurring_amount])[0].delete('£')}", @white]]
                    if intTypeId == 2
                        color[0] = @green
                    else
                        color[0] = @red
                    end
                end

                row do
                    column(" #{recognizedTransaction[:translation]}", :color => (intTypeId == 2) ? 47 : 196)
                    column(amt1[0] <= 0 ? '—' : "#{intTypeId == 3 && recognizedTransaction[:estimated].nil? ? '—' : ''}#{amt1[1][0]}", :color => amt1[0] <= 0 ? @white : color[0])
                    column(amt2[0] <= 0 ? '—' : "#{intTypeId == 3 ? '—' : ''}#{amt2[1][0]}", :color => amt2[0] <= 0 ? @white : color[1])
                    column(amt3[0] <= 0 ? '—' : "#{intTypeId == 3 ? '—' : ''}#{amt3[1][0]}", :color => amt3[0] <= 0 ? @white : color[2])
                    column(amt4[0] <= 0 ? '—' : "#{intTypeId == 3 ? '—' : ''}#{amt4[1][0]}", :color => amt4[0] <= 0 ? @white : color[3])
                    column(amt5[0] <= 0 ? '—' : "#{intTypeId == 3 ? '—' : ''}#{amt5[1][0]}", :color => amt5[0] <= 0 ? @white : color[4])
                    column(amtTotal[0] <= 0 ? '—' : "#{intTypeId == 3 ? '—' : ''}#{amtTotal[1][0]}", :color => amtTotal[0] <= 0 ? @white : color[5])
                    column(' |')
                    column(insertRightHandContent[0], :color => insertRightHandContent[1])
                end
            end
        end
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
            if @rightHandSideContentExists
                return Array['', @white]

                # DO NOT DELETE!
                # The following line of code would insert '----' between the outputs.
                #
                # return Array[" #{getRuleString(@summaryWidth_9 - 1)}", @white]

            else
                return Array['', @white]
            end
        end
        content = ''
        color = 208
        if !@rightHandSideContent[@rightHandSideContentCount].nil?
            content = @rightHandSideContent[@rightHandSideContentCount][0]
            color = @rightHandSideContent[@rightHandSideContentCount][1]
        else
            @rightHandSideContentExists = false
        end
        Array[content, color]
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

    # Get all the totals (for current month)
    # @return void
    def getTotals
        totals = calculateTotals(@bankAccountBalances)
        @totalAvailable = totals[:totalAvailable]
        @totalCreditUsed = totals[:totalCreditUsed]
        @totalCredit = totals[:totalCredit]
        @totalCash = totals[:totalCash]
    end

    # @return object
    def calculateTotals(data)

        # If any of the balances are nil, abort mission
        data.each do |object|
            object.each do |value|
                if value.nil?
                    return {
                        :totalAvailable => nil,
                        :totalCreditUsed => nil,
                        :totalCredit => nil,
                        :totalCash => nil
                    }
                end
            end
        end

        totalAvailable =
            (data[1]['balance_available'].to_f +
                data[2]['balance_available'].to_f +
                data[4]['balance_available'].to_f +
                data[5]['balance_available'].to_f +
                data[7]['balance_available'].to_f +
                data[8]['balance_available'].to_f +
                data[9]['balance_available'].to_f +
                data[10]['balance_available'].to_f +
                data[11]['balance_available'].to_f).round(2)

        totalCreditUsed =
            (data[7]['balance'].to_f +
                data[7]['pending_transactions'].to_f +
                data[10]['balance'].to_f +
                data[10]['pending_transactions'].to_f +
                data[9]['balance'].to_f +
                data[9]['pending_transactions'].to_f +
                data[11]['balance'].to_f +
                data[11]['pending_transactions'].to_f +
                (data[1]['balance'].to_f < 0 ? -data[1]['balance'].to_f : 0) +
                (data[2]['balance'].to_f < 0 ? -data[2]['balance'].to_f : 0) +
                (data[4]['balance'].to_f < 0 ? -data[4]['balance'].to_f : 0) +
                (data[5]['balance'].to_f < 0 ? -data[5]['balance'].to_f : 0) +
                (data[8]['balance'].to_f < 0 ? -data[8]['balance'].to_f : 0)).round(2)

        totalCredit =
            (data[1]['balance_overdraft'].to_f +
                data[2]['balance_overdraft'].to_f +
                data[4]['balance_overdraft'].to_f +
                data[5]['balance_overdraft'].to_f +
                data[8]['balance_overdraft'].to_f +
                data[7]['balance_limit'].to_f +
                data[9]['balance_limit'].to_f +
                data[10]['balance_limit'].to_f +
                data[11]['balance_limit'].to_f).round(2)

        totalCash = (totalAvailable - totalCredit).round(2)

        {
            :totalAvailable => totalAvailable,
            :totalCreditUsed => totalCreditUsed,
            :totalCredit => totalCredit,
            :totalCash => totalCash,
        }

    end

    # Get summary data for 5 month output
    # @return void
    def calculateSummary

        # Get start of month balances
        Array[@month1, @month2, @month3, @month4, @month5].each do |month|
            # Get start of month balances.
            thisMonthBalances = {}
            @bankAccounts.each do |bankAccount|
                bankAccount = bankAccount[1]
                case bankAccount['bank_account_type_id'].to_i
                    when 1
                        bankAccountTable = 'bank_account_type_bank_account'
                    when 2
                        bankAccountTable = 'bank_account_type_credit_card'
                    when 3
                        bankAccountTable = 'bank_account_type_isa'
                    else
                        raise(RuntimeError, "bank_account_type => #{bankAccount['bank_account_type']} doesn't exist.")
                end
                balance = @databaseConnection.query("SELECT * FROM #{bankAccountTable} WHERE bank_account_id='#{bankAccount['id']}' AND (date_fetched>='#{month.strftime('%Y-%m-01')}' AND date_fetched<='#{month.strftime('%Y-%m-07')}') ORDER BY date_fetched ASC LIMIT 1")
                thisMonthBalances[bankAccount['id'].to_i] = balance.fetch_hash
                balance.free
            end
            monthObject = getMonthObject(month.strftime('%Y-%m'))
            monthObject[:starting_balances] = calculateTotals(thisMonthBalances)
        end

        @transactions.each do |transaction|

            # Skip internal transfers
            if isInternalTransfer(transaction)
                next
            end

            # Find out what month we're in and retrieve relevant location in memory for object.
            monthObject = getMonthObject(DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%Y-%m'))

            # If it's a month we don't recognize, skip to next transaction.
            if monthObject.nil?
                next
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
            unless transactionAdded
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

        # Monthly Totals
        @summaryData.each do |monthObject|
            if monthObject[0].to_s != 'monthTotal'
                monthObject[1].each do |key, value|
                    unless key.to_s == 'starting_balances'
                        if @summaryData[:monthTotal][:"#{key}"].nil?
                            @summaryData[:monthTotal][:"#{key}"] = 0
                        end
                        @summaryData[:monthTotal][:"#{key}"] = @summaryData[:monthTotal][:"#{key}"] + value
                    end
                end
            end
        end

        # Montly Profit Loss
        @summaryData.each do |monthObject|
            monthObject[1][:profit_loss] = monthObject[1][:total_in] - monthObject[1][:total_out]
        end
    end

    # @return array
    def calculateAmountPaidReceivedForRecognizedTransaction(month, id)
        case month.strftime('%m')
            when @month1.strftime('%m')
                amt = @summaryData[:month1][:"#{id}"].to_f
            when @month2.strftime('%m')
                amt = @summaryData[:month2][:"#{id}"].to_f
            when @month3.strftime('%m')
                amt = @summaryData[:month3][:"#{id}"].to_f
            when @month4.strftime('%m')
                amt = @summaryData[:month4][:"#{id}"].to_f
            when @month5.strftime('%m')
                amt = @summaryData[:month5][:"#{id}"].to_f
            else
                raise(RuntimeError('Month not found.'))
        end
        amt
    end

    # @return void
    def calculateMoneyRemaining
        @recognizedTransactions.each do |rt|
            if rt[:intTypeID] == 2 || rt[:intTypeID] == 3
                transactionFound = false
                @transactions.each do |transaction|
                    if @month1.strftime('%Y-%m') == DateTime.strptime(transaction['date'], '%Y-%m-%d').strftime('%Y-%m')
                        if transaction['bank_account_id'].to_i == rt[:bank_account_id] && transaction['type'] == rt[:type] && rt[:terms].any? { |w| transaction['description'] =~ /#{w}/ }
                            transactionFound = true
                        end
                    end
                end
                if !transactionFound
                    if rt[:intTypeID] == 2
                        @moneyInRemaining = @moneyInRemaining + rt[:recurring_amount]
                    elsif rt[:intTypeID] == 3
                        @moneyOutRemaining = @moneyOutRemaining + rt[:recurring_amount]
                    end
                end
            end
        end
    end

    # @return void
    def calculateFixedMonthlyOutgoings
        @recognizedTransactions.each do |rt|
            if rt[:intTypeID] == 3
                @fixedMonthlyOutgoings = @fixedMonthlyOutgoings + rt[:recurring_amount]
            end
        end
    end

    # @return float
    def calculateCreditUsed
        if @totalCreditUsed.to_f > 0
            ((@totalCreditUsed.to_f / @totalCredit.to_f) * 100).round(2)
        else
            0
        end
    end

    # @return array
    def getCreditScore
        creditScore = @databaseConnection.query('SELECT * FROM experian_credit_report ORDER BY date_fetched DESC LIMIT 1')
        creditScore = creditScore.fetch_hash
        @creditScore = Array[creditScore['score'], creditScore['score_text']]
    end

    # Returns name of bank account + associated color.
    def getBankAndColor(bankId)

        returnHash = {}
        returnHash[0] = @banks[bankId.to_s]
        case bankId.to_i
            when 1
                returnHash[1] = @magenta
            when 2
                returnHash[1] = @blue
            when 3
                returnHash[1] = @green
            when 4
                returnHash[1] = @cyan
            when 5
                returnHash[1] = 113
            else
                returnHash[1] = @white
        end
        returnHash
    end

    # @return float
    def getBalanceAfterBills
        (@totalCash + @moneyInRemaining) - @moneyOutRemaining
    end

    # Parameter passed in must be in string form as '%Y-%m'
    # @return object
    def getMonthObject(transactionMonth)
        case transactionMonth
            when @month1.strftime('%Y-%m')
                monthObject = @summaryData[:month1]
            when @month2.strftime('%Y-%m')
                monthObject = @summaryData[:month2]
            when @month3.strftime('%Y-%m')
                monthObject = @summaryData[:month3]
            when @month4.strftime('%Y-%m')
                monthObject = @summaryData[:month4]
            when @month5.strftime('%Y-%m')
                monthObject = @summaryData[:month5]
            else
                monthObject = nil
        end
        monthObject
    end

    # Calculates (depending on the last 4 month trend) how much money I should have by the end of the month.
    # @return float
    def getProjectedOEMBalance

        averageIn =
            ((@summaryData[:month2][:total_in] +
                @summaryData[:month3][:total_in] +
                @summaryData[:month4][:total_in] +
                @summaryData[:month5][:total_in]) / 4).round(2)

        averageOut =
            ((@summaryData[:month2][:total_out] +
                @summaryData[:month3][:total_out] +
                @summaryData[:month4][:total_out] +
                @summaryData[:month5][:total_out]) / 4).round(2)

        if @summaryData[:month1][:starting_balances][:totalCash].nil?
            return nil
        end

        (@summaryData[:month1][:starting_balances][:totalCash] + averageIn) - averageOut

    end

    # Calculates (depending on the last 4 month trend) how much money I should have by the end of the month.
    # @return float
    def getProjectedOEMBalanceDeprecated

        averageCashIn =
            ((@summaryData[:month2][:cash_in] +
                @summaryData[:month3][:cash_in] +
                @summaryData[:month4][:cash_in] +
                @summaryData[:month5][:cash_in]) / 4).round(2)

        averageMiscIn =
            ((@summaryData[:month2][:misc_in] +
                @summaryData[:month3][:misc_in] +
                @summaryData[:month4][:misc_in] +
                @summaryData[:month5][:misc_in]) / 4).round(2)

        averageMiscOut =
            ((@summaryData[:month2][:misc_out] +
                @summaryData[:month3][:misc_out] +
                @summaryData[:month4][:misc_out] +
                @summaryData[:month5][:misc_out]) / 4).round(2)

        # An estimate of how much 'MISC' goes in/out based on last 4 months.
        inAdjustment = (averageMiscIn - @summaryData[:month1][:misc_in]) + (averageCashIn - @summaryData[:month1][:cash_in])
        outAdjustment = (averageMiscOut - @summaryData[:month1][:misc_out])

        # Calculate how much % of month is left...
        totalDaysInCurrentMonth = Date.civil(@month1.strftime('%Y').to_i, @month1.strftime('%m').to_i, -1).day
        currentDay = @month1.strftime('%d')
        percentOfMonthLeft = 100 - (currentDay.to_f / (totalDaysInCurrentMonth.to_f / 100))

        # ...and adjust adjustments accordingly.
        inAdjustment = inAdjustment * (percentOfMonthLeft / 100)
        outAdjustment = outAdjustment * (percentOfMonthLeft / 100)

        # Add ajustments to @moneyRemaining variables.
        moneyInRemaining = @moneyInRemaining + inAdjustment
        moneyOutRemaining = @moneyOutRemaining + outAdjustment

        (@totalCash - moneyOutRemaining) + moneyInRemaining
    end

    # Gets end of month day (for current month)
    # @return int
    def getEndOfMonthDay
        Date.civil(@month1.strftime('%Y').to_i, @month1.strftime('%m').to_i, -1).day.to_i
    end

    # Returns '━━━━'
    # @retrun string
    def getRuleString(length, delimiter = '━')
        ruleString = ''
        for i in 0..length - 1
            ruleString = "#{ruleString}#{delimiter}"
        end
        ruleString
    end

    # Returns the amount as currency formatted string with color (as hash)
    # return object
    def getAsCurrency(amount, symbol = '£', delimiter = ',')
        amount = amount.to_f
        returnHash = {}

        # Set index '1' to color
        if amount < 0
            returnHash[1] = @red
        else
            returnHash[1] = @green
        end

        # Set index '0' to formatted amount
        minus = (amount < 0) ? '-' : ''
        amount = '%.2f' % amount.abs
        amount = amount.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
        returnHash[0] = "#{minus}#{symbol}#{amount}"
        returnHash
    end

    # If timestamp is blank, this gives it a normalized timestamp so script doesn't error.
    # @return string
    def normalizeTimestamp(timestamp)
        if timestamp == '0000-00-00 00:00:00' || timestamp == '0000-00-00T00:00:00+00:00'
            timestamp = '1983-10-29T03:16:00+00:00'
        end
        timestamp
    end

    # Gives a prompt where ONLY 'Enter' will clear the screen, any other key will not.
    # @return void
    def enter_to_clear
        begin
            system('stty raw -echo')
            response = STDIN.getc
        ensure
            system('stty -raw echo')
        end
        if response.chr == "\r"
            system('clear')
        end
        exit
    end

end

ShowBankTransactions.new(ARGV[0]).run