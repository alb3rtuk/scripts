require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class BankBarclayCard

    include CommandLineReporter

    def initialize(username, pin, security, displays = 'single', headless = false, displayProgress = false, databaseConnection = nil)
        @username = username
        @pin = pin
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://bcol.barclaycard.co.uk/ecom/as2/initialLogon.do'
        @databaseConnection = databaseConnection
    end

    # Gets you as far as BarclayCard account overview screen & then returns the browser for (possible) further manipulation.
    def login(browser = getBrowser(@displays, @headless))
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)
        browser.text_field(:name => 'username').set @username
        browser.text_field(:name => 'password').set @pin
        browser.checkbox(:name => 'remember').set
        browser.input(:type => 'submit', :value => 'Continue').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        browser.select_list(:name => 'firstAnswer').option(:value => getCharAt(browser.label(:for => 'lettera').text.gsub(/[^0-9]/, ''), @security)).select
        browser.select_list(:name => 'secondAnswer').option(:value => getCharAt(browser.label(:for => 'letterb').text.gsub(/[^0-9]/, ''), @security)).select
        browser.input(:type => 'submit', :value => 'Log in').click
        if browser.link(:id => 'confirmpd').exists?
            browser.link(:id => 'confirmpd').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed occasional confirmation page\x1B[0m\n"
            end
        end
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to BarclayCard\x1B[0m\n"
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
                    cronLog"BarclayCard: Attempt #{attempt} failed with message: #{e.message}."
                    # puts e.backtrace
                end
            else
                succeeded = true
            ensure
                if succeeded

                    @databaseConnection.query("INSERT INTO bank_account_type_credit_card (bank_account_id, balance, balance_available, pending_transactions, balance_limit, date_fetched, date_fetched_string, minimum_payment, minimum_payment_date) VALUES (9, #{data['balance']}, #{data['available_funds']}, #{data['pending_transactions']}, #{data['credit_limit']}, '#{DateTime.now}', '#{DateTime.now}', #{data['minimum_payment']}, '#{data['due_date']}')")
                    BankCommon.new.insertTransactions(@databaseConnection, data['main_card'], 9)
                    # Check if existing transactions (in last month) still exist
                    objectData = Array[
                        {:bank_account_id => 9, :transactions => data['main_card']},
                    ]
                    BankCommon.new.checkIfTransactionStillExist(@databaseConnection, objectData)
                    if showInTerminal
                        puts "\x1B[32mSuccess (BarclayCard)\x1B[0m"
                    end

                else
                    if attempt >= 1
                        succeeded = true
                        if showInTerminal
                            puts "\x1B[31mSite is either down or there is an error in the BarclayCard script.\x1B[0m"
                        end
                    end
                end
            end
        end
    end

    def getBalances(showInTerminal = false, browser = self.login)
        data = {}
        data['balance'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 0).text.delete('£').delete(',').to_f
        data['available_funds'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 2).text.delete('£').delete(',').to_f
        data['credit_limit'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 3).text.delete('£').delete(',').to_f
        data['minimum_payment'] = browser.div(:class => 'panelSummary', :index => 1).p(:class => 'figure', :index => 2).text.delete('£').delete(',').to_f
        data['due_date'] = DateTime.strptime(browser.div(:class => 'panelSummary', :index => 1).p(:class => 'figure', :index => 3).text, '%d %b %y')
        data['pending_transactions'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 1).text.delete('£').delete(',').to_f

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

        browser.link(:id => 'ASCSKn4', :text => 'Check your statements').hover
        sleep(1)
        browser.link(:id => 'ASCSKn6', :text => 'See all your available statements').when_present(5).click

        pageIndex = 0
        while pageIndex <= 5
            browser.select_list(:id => 'dateSelect', :name => 'statementDate').option(:index => pageIndex).select
            sleep(1)
            if browser.table(:class => 'dualCardTable').exists?
                data_main_card.push(*getTransactionsFromTable(browser.table(:class => 'dualCardTable')))
            end
            pageIndex = pageIndex + 1
        end
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved transactions for \x1B[33mBarclayCard\x1B[0m"
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
                    rowData['description'] = tableCell.text
                elsif cellCount == 4
                    rowData['type'] = tableCell.text
                elsif cellCount == 7
                    rowData['amount'] = tableCell.text
                end
            end
            unless rowData.empty?
                transactions << rowData
            end
        end
        transactions.pop
        transactions.pop
        transactions.pop
        sanitizeTransactions(transactions)
    end

    # Takes transaction data and sanitizes it.
    def sanitizeTransactions(transactions)
        sanitizedArray = Array.new
        unless transactions.empty?
            transactions.each do |transaction|
                newData = {}
                # Date
                newData['date'] = DateTime.strptime(transaction['date'], '%d %b %y').strftime('%Y-%m-%d')
                # Description
                newData['description'] = replaceLineBreaks(transaction['description'])
                # Paid In/Out
                if transaction['amount'].include? 'CR'
                    newData['paid_in'] = transaction['amount'].delete('CR\n').delete('£').delete(' ').to_f
                    newData['paid_out'] = 0
                else
                    newData['paid_in'] = 0
                    newData['paid_out'] = transaction['amount'].delete('£').to_f
                end
                # DUD INFO
                newData['type'] = transaction['type'].delete(' ').upcase
                newData['balance'] = 0
                sanitizedArray << newData
            end
        end
        sanitizedArray
    end

end