require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')

class BankCapitalOne
    include CommandLineReporter

    def initialize(username, security, displays = 'single', headless = false, displayProgress = false, databaseConnection = nil)
        @username = username
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.capitaloneonline.co.uk/CapitalOne_Consumer/Login.do'
        @databaseConnection = databaseConnection
    end

    # Gets you as far as CapitalOne account overview screen & then returns the browser for (possible) further manipulation.
    def login(browser = getBrowser(@displays, @headless))
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)


        browser.text_field(:name => 'username').set @username
        browser.checkbox(:name => 'rememberMeFlag').set
        browser.text_field(:name => 'password.randomCharacter0').set getCharAt(browser.div(:class => 'pass-char').p(:index => 0).text.gsub(/[^0-9]/, ''), @security)
        browser.text_field(:name => 'password.randomCharacter1').set getCharAt(browser.div(:class => 'pass-char').p(:index => 1).text.gsub(/[^0-9]/, ''), @security)
        browser.text_field(:name => 'password.randomCharacter2').set getCharAt(browser.div(:class => 'pass-char').p(:index => 2).text.gsub(/[^0-9]/, ''), @security)
        browser.input(:type => 'submit', :value => 'SIGN IN').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        if browser.input(:type => 'submit', :value => 'CONFIRM EMAIL').exists?
            browser.input(:type => 'submit', :value => 'CONFIRM EMAIL').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed (occasional) email confirmation page\x1B[0m\n"
            end
        end
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to CapitalOne\x1B[0m\n"
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
                data[0].close
                data = data[1]
            rescue Exception => e
                succeeded = false
                if showInTerminal
                    puts "\x1B[31mAttempt #{attempt} failed with message: \x1B[90m#{e.message}.\x1B[0m"
                    cronLog"Capital One: Attempt #{attempt} failed with message: #{e.message}."
                end
            else
                succeeded = true
            ensure
                if succeeded

                    @databaseConnection.query("INSERT INTO bank_account_type_credit_card (bank_account_id, balance, balance_available, balance_limit, date_fetched, date_fetched_string, minimum_payment, minimum_payment_date) VALUES (10, #{data['balance']}, #{data['available_funds']}, #{data['credit_limit']}, '#{DateTime.now}', '#{DateTime.now}', #{data['minimum_payment']}, '#{data['due_date']}')")
                    BankCommon.new.insertTransactions(@databaseConnection, data['main_card'], 10)
                    # Check if existing transactions (in last month) still exist
                    objectData = Array[
                        {:bank_account_id => 10, :transactions => data['main_card']},
                    ]
                    BankCommon.new.checkIfTransactionStillExist(@databaseConnection, objectData)
                    if showInTerminal
                        puts "\x1B[32mSuccess (Capital One)\x1B[0m"
                    end

                else
                    if attempt >= 5
                        succeeded = true
                        if showInTerminal
                            puts "\x1B[31mSite is either down or there is an error in the Capital One script.\x1B[0m"
                        end
                    end
                end
            end
        end
    end

    def getBalances(showInTerminal = false, browser = self.login)
        data = {}
        data['balance'] = browser.td(:text, /Current balance/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['available_funds'] = browser.td(:text, /Available to spend/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['credit_limit'] = browser.td(:text, /Credit limit/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['minimum_payment'] = browser.td(:text, /Minimum payment/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['due_date'] = DateTime.strptime(browser.td(:text, /Payment due date/).parent.cell(:index => 1).text, '%d-%m-%Y').strftime('%Y-%m-%d')

        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved balances\x1B[0m"
        end

        Array[browser, data]
    end

    def getAllData(showInTerminal = false, browser = self.login)
        data_main_card = Array.new

        # Get balances first
        data = getBalances(false, browser)
        data = data[1]

        browser.input(:type => 'submit', :value => 'VIEW ALL TRANSACTIONS').when_present(5).click

        pageIndex = 0
        while pageIndex <= 5
            browser.select_list(:name => 'cycleDate').option(:index => pageIndex).select
            browser.input(:type => 'submit', :value => 'VIEW TRANSACTIONS').click
            if browser.div(:class => 'chart').table.exists?
                data_main_card.push(*getTransactionsFromTable(browser.div(:class => 'chart').table))
            end
            pageIndex = pageIndex + 1
        end
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved transactions for \x1B[36mCapital One Visa\x1B[0m"
        end

        # Add transactions to final array
        data['main_card'] = data_main_card

        Array[browser, data]
    end

    # Takes table and gets transactions from that.
    def getTransactionsFromTable(table)
        rowCount = 0
        transactions = Array.new
        table.rows.each do |tableRow|
            rowCount = rowCount + 1
            if rowCount <= 1
                next
            end
            rowData = {}
            cellCount = 0
            tableRow.cells.each do |tableCell|

                # If no transactions, break out of loop immediately.
                if tableCell.text.include? 'There were no transactions for the selected period.'
                    break;
                elsif tableCell.text.include? 'No current transactions have been posted to your account.'
                    break;
                end

                cellCount = cellCount + 1
                if cellCount == 1
                    rowData['date'] = tableCell.text
                elsif cellCount == 2
                    rowData['description'] = tableCell.text
                elsif cellCount == 3
                    rowData['paid_out'] = tableCell.text
                elsif cellCount == 4
                    rowData['paid_in'] = tableCell.text
                end
            end
            unless rowData.empty?
                transactions << rowData
            end
        end
        sanitizeTransactions(transactions)
    end

    # Takes transaction data and sanitizes it.
    def sanitizeTransactions(transactions)
        sanitizedArray = Array.new
        unless transactions.empty?
            transactions.each do |transaction|
                newData = {}
                # Date
                newData['date'] = DateTime.strptime(transaction['date'], '%d-%m-%Y').strftime('%Y-%m-%d')
                # Description
                newData['description'] = transaction['description']
                # Paid In/Out
                newData['paid_in'] = transaction['paid_in'].delete(',').delete('£').to_f
                newData['paid_out'] = transaction['paid_out'].delete(',').delete('£').to_f
                # DUD INFO
                newData['type'] = (newData['paid_in'] > 0) ? 'CR' : 'CC'
                newData['balance'] = 0
                sanitizedArray << newData
            end
        end
        sanitizedArray
    end

end