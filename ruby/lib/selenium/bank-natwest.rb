require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-common.rb'

class BankNatWest
    include CommandLineReporter

    def initialize(username, security_top, security_bottom, displays = 'single', headless = false, displayProgress = false, databaseConnection = nil)
        @username = username
        @security_top = security_top
        @security_bottom = security_bottom
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.nwolb.com/default.aspx'
        @databaseConnection = databaseConnection
    end

    # Gets you as far as NatWest account overview screen & then returns the browser for (possible) further manipulation.
    def login(browser = getBrowser(@displays, @headless))
        f = 'ctl00_secframe'
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)
        browser.frame(:id => f).text_field(:name => 'ctl00$mainContent$LI5TABA$DBID_edit').set @username
        browser.frame(:id => f).checkbox(:id => 'ctl00_mainContent_LI5TABA_LI5CBB').set
        browser.frame(:id => f).input(:id => 'ctl00_mainContent_LI5TABA_LI5-LBA_button_button').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEA_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALALabel').text.gsub(/[^0-9]/, ''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEB_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALBLabel').text.gsub(/[^0-9]/, ''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEC_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALCLabel').text.gsub(/[^0-9]/, ''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPED_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALDLabel').text.gsub(/[^0-9]/, ''), @security_bottom)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEE_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALELabel').text.gsub(/[^0-9]/, ''), @security_bottom)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEF_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALFLabel').text.gsub(/[^0-9]/, ''), @security_bottom)
        browser.frame(:id => f).checkbox(:id => 'TimeoutCheckbox-LI6CBA').set
        browser.frame(:id => f).input(:id => 'ctl00_mainContent_Tab1_next_text_button_button').click
        # Occasional 'Important Information' Page
        if browser.frame(:id => f).checkbox(:id => 'ctl00_mainContent_LI1CBA').exists?
            browser.frame(:id => f).checkbox(:id => 'ctl00_mainContent_LI1CBA').set
            browser.frame(:id => f).input(:id => 'ctl00$mainContent$FinishButton_button').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed (occasional) important information page\x1B[0m\n"
            end
        elsif browser.frame(:id => f).input(:value => 'Confirm').exists?
            browser.frame(:id => f).input(:value => 'Confirm').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed (occasional) important information page\x1B[0m\n"
            end
        end
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to NatWest\x1B[0m\n"
        end
        browser
    end

    def runExtraction(showInTerminal = false)
        attempt = 0
        succeeded = false
        while !succeeded
            begin
                attempt = attempt + 1
                data = getAllData(showInTerminal)
                data = data[1]
            rescue Exception => e
                succeeded = false
                if showInTerminal
                    puts "\x1B[31mAttempt #{attempt} failed with message: \x1B[90m#{e.message}.\x1B[0m"
                    # puts e.backtrace
                end
            else
                succeeded = true
            ensure
                if succeeded
                    @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched, date_fetched_string) VALUES (1, #{data['select_platinum_balance']}, #{data['select_platinum_available']}, #{data['select_platinum_overdraft']}, '#{DateTime.now}', '#{DateTime.now}')")
                    @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched, date_fetched_string) VALUES (2, #{data['step_account']}, #{data['step_account']}, 0, '#{DateTime.now}', '#{DateTime.now}')")
                    @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched, date_fetched_string) VALUES (3, #{data['savings_account']}, #{data['savings_account']}, 0, '#{DateTime.now}', '#{DateTime.now}')")
                    BankCommon.new.insertTransactions(@databaseConnection, data['select_platinum_transactions'], 1)
                    BankCommon.new.insertTransactions(@databaseConnection, data['step_account_transactions'], 2)
                    BankCommon.new.insertTransactions(@databaseConnection, data['savings_account_transactions'], 3)
                    # Check if existing transactions (in last month) still exist
                    objectData = Array[
                        {:bank_account_id => 1, :transactions => data['select_platinum_transactions']},
                        {:bank_account_id => 2, :transactions => data['step_account_transactions']},
                        {:bank_account_id => 3, :transactions => data['savings_account_transactions']}
                    ]
                    BankCommon.new.checkIfTransactionStillExist(@databaseConnection, objectData)
                    if showInTerminal
                        puts "\x1B[32mSuccess (NatWest)\x1B[0m"
                    end

                else
                    if attempt >= 5
                        succeeded = true
                        if showInTerminal
                            puts "\x1B[31mSite is either down or there is an error in the NatWest script.\x1B[0m"
                        end
                    end
                end
            end
        end
    end

    def getBalances(showInTerminal = false, browser = self.login)
        showInTerminal
        f = 'ctl00_secframe'
        data = {}
        data['select_platinum_balance'] = browser.frame(:id => f).tr(:id => 'Account_A412AD6062AE989A9FCDAEB7D9ED8A594808AC87').td(:class => 'currency', :index => 0).text.delete('£').delete(',').to_f
        data['select_platinum_available'] = browser.frame(:id => f).tr(:id => 'Account_A412AD6062AE989A9FCDAEB7D9ED8A594808AC87').td(:class => 'currency', :index => 1).text.delete('£').delete(',').to_f
        data['select_platinum_overdraft'] = 7500 # This is hard-coded because there is no way to determine what the O/D Limit is from the website.
        data['savings_account'] = browser.frame(:id => f).tr(:id => 'Account_CE99D6FF6219B59BB28B6A42825D98D60B92326C').td(:class => 'currency', :index => 1).text.delete('£').delete(',').to_f
        data['step_account'] = browser.frame(:id => f).tr(:id => 'Account_FAB7EFB59260BED0F1081E761570BF4227C37E6B').td(:class => 'currency', :index => 1).text.delete('£').delete(',').to_f

        # TEMP £5000 ADJUSTMENT TO MINIMIZE OVERDRAFT FEES
        data['savings_account'] = data['savings_account'] + 5000

        Array[browser, data]
    end

    def getAllData(showInTerminal = false, browser = self.login)
        f = 'ctl00_secframe'
        data_platinum = Array.new
        data_step = Array.new
        data_savings = Array.new

        # Get balances first
        data = getBalances(false, browser)
        data = data[1]

        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved balances\x1B[0m"
        end

        # Get PLATINUM transactions
        browser.frame(:id => f).link(:id => 'ctl00_mainContent_Accounts_Accounts_AccountTable_A412AD6062AE989A9FCDAEB7D9ED8A594808AC87_AS5ALBAnchor').click
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2ACCDDA').option(:value => 'A412AD6062AE989A9FCDAEB7D9ED8A594808AC87').select
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2SPDDA').option(:value => 'M1').select
        browser.frame(:id => f).input(:type => 'submit', :id => 'ctl00_mainContent_NextButton_button').click
        if browser.frame(:id => f).div(:class => 'noItemsToDisplay').exists?
            if showInTerminal
                puts "\x1B[90mNo transactions found in last 2 weeks for \x1B[33mPlatinum Account\x1B[0m"
            end
        else
            if browser.frame(:id => f).link(:title => 'Show all items on a single page').exists?
                browser.frame(:id => f).link(:title => 'Show all items on a single page').click
            end
            data_platinum = getTransactionsFromTable(browser.frame(:id => f).table(:id => 'ctl00_mainContent_SS4ITA'))
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[33mPlatinum Account\x1B[90m transactions\x1B[0m"
            end
        end
        browser.frame(:id => f).link(:href => 'https://www.nwolb.com/AccountSummary2.aspx').click

        # Get STEP transactions
        browser.frame(:id => f).link(:id => 'ctl00_mainContent_Accounts_Accounts_AccountTable_FAB7EFB59260BED0F1081E761570BF4227C37E6B_AS5ALBAnchor').click
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2ACCDDA').option(:value => 'FAB7EFB59260BED0F1081E761570BF4227C37E6B').select
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2SPDDA').option(:value => 'M1').select
        browser.frame(:id => f).input(:type => 'submit', :id => 'ctl00_mainContent_NextButton_button').click
        if browser.frame(:id => f).div(:class => 'noItemsToDisplay').exists?
            if showInTerminal
                puts "\x1B[90mNo transactions found in last month for \x1B[33mSTEP Account\x1B[0m"
            end
        else
            if browser.frame(:id => f).link(:title => 'Show all items on a single page').exists?
                browser.frame(:id => f).link(:title => 'Show all items on a single page').click
            end
            data_step = getTransactionsFromTable(browser.frame(:id => f).table(:id => 'ctl00_mainContent_SS4ITA'))
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[33mSTEP Account\x1B[90m transactions\x1B[0m"
            end
        end
        browser.frame(:id => f).link(:href => 'https://www.nwolb.com/AccountSummary2.aspx').click

        # Get Savings transactions
        browser.frame(:id => f).link(:id => 'ctl00_mainContent_Accounts_Accounts_AccountTable_CE99D6FF6219B59BB28B6A42825D98D60B92326C_AS5ALBAnchor').click
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2ACCDDA').option(:value => 'CE99D6FF6219B59BB28B6A42825D98D60B92326C').select
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_SS2SPDDA').option(:value => 'M1').select
        browser.frame(:id => f).input(:type => 'submit', :id => 'ctl00_mainContent_NextButton_button').click
        if browser.frame(:id => f).div(:class => 'noItemsToDisplay').exists?
            if showInTerminal
                puts "\x1B[90mNo transactions found in last month for \x1B[33mSavings Account\x1B[0m"
            end
        else
            if browser.frame(:id => f).link(:title => 'Show all items on a single page').exists?
                browser.frame(:id => f).link(:title => 'Show all items on a single page').click
            end
            data_savings = getTransactionsFromTable(browser.frame(:id => f).table(:id => 'ctl00_mainContent_SS4ITA'))
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[33mSavings Account\x1B[90m transactions\x1B[0m"
            end
        end
        browser.frame(:id => f).link(:href => 'https://www.nwolb.com/AccountSummary2.aspx').click

        # Add transactions to final array
        data['select_platinum_transactions'] = data_platinum
        data['step_account_transactions'] = data_step
        data['savings_account_transactions'] = data_savings

        Array[browser, data]
    end

    # Takes table and gets transactions from that.
    def getTransactionsFromTable(table)
        rowCount = 0
        transactions = Array.new
        table.rows.each do |tableRow|
            rowCount = rowCount + 1
            if rowCount <= 2
                next
            end
            rowData = {}
            cellCount = 0
            tableRow.cells.each do |tableCell|
                cellCount = cellCount + 1
                if cellCount == 1
                    rowData['date'] = tableCell.text
                elsif cellCount == 2
                    rowData['type'] = tableCell.text
                elsif cellCount == 3
                    rowData['description'] = tableCell.text
                elsif cellCount == 4
                    rowData['paid_in'] = tableCell.text
                elsif cellCount == 5
                    rowData['paid_out'] = tableCell.text
                elsif cellCount == 6
                    rowData['balance'] = tableCell.text
                end
            end
            transactions << rowData
        end
        transactions.pop
        sanitizeTransactions(transactions)
    end

    # Takes transaction data and sanitizes it.
    def sanitizeTransactions(transactions)
        sanitizedArray = Array.new
        transactions.each do |transaction|
            newData = {}
            # Date
            date = Date.parse(transaction['date'])
            newData['date'] = date.strftime('%Y-%m-%d')
            # Type
            newData['type'] = transaction['type']
            # Description
            newData['description'] = transaction['description']
            # Paid In/Out
            newData['paid_in'] = transaction['paid_in'].delete(',').to_f
            newData['paid_out'] = transaction['paid_out'].delete(',').to_f
            newData['balance'] = transaction['balance'].delete('£').delete(',').to_f
            sanitizedArray << newData
        end
        sanitizedArray
    end
end