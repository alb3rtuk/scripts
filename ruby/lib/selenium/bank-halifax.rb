require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/selenium/bank-common.rb'

class BankHalifax
    include CommandLineReporter

    def initialize(username, password, security, displays = 'single', headless = false, displayProgress = false, databaseConnection = nil)
        @username = username
        @password = password
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.halifax-online.co.uk/personal/logon/login.jsp'
        @databaseConnection = databaseConnection
    end

    # Gets you as far as Halifax account overview screen & then returns the browser for (possible) further manipulation.
    def login(browser = getBrowser(@displays, @headless))
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)
        browser.text_field(:name => 'frmLogin:strCustomerLogin_userID').set @username
        browser.text_field(:name => 'frmLogin:strCustomerLogin_pwd').set @password
        browser.checkbox(:name => 'frmLogin:loginRemember').set
        browser.input(:id => 'frmLogin:btnLogin1').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        browser.select_list(:name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1').option(:value => "&nbsp;#{getCharAt(browser.label(:for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1').text.gsub(/[^0-9]/, ''), @security)}").select
        browser.select_list(:name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2').option(:value => "&nbsp;#{getCharAt(browser.label(:for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2').text.gsub(/[^0-9]/, ''), @security)}").select
        browser.select_list(:name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3').option(:value => "&nbsp;#{getCharAt(browser.label(:for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3').text.gsub(/[^0-9]/, ''), @security)}").select
        browser.input(:id => 'frmentermemorableinformation1:btnContinue').click
        if browser.input(:id => 'frm2:btnContinue2', :type => 'image').exists?
            browser.input(:id => 'frm2:btnContinue2', :type => 'image').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed (occasional) email confirmation page\x1B[0m\n"
            end
        end
        # Occasional 'Important Update' Page
        if browser.checkbox(:id => 'frmmandatoryMsgs:msgList1:0:chktmpMsgRead1').exists?
            browser.checkbox(:id => 'frmmandatoryMsgs:msgList1:0:chktmpMsgRead1').set
            if @displayProgress
                puts "\x1B[90mTicked checkbox to confirm I've read a message\x1B[0m\n"
            end
        end
        if browser.checkbox(:id => 'frmmandatoryMsgs:tmpAllMsgsRead').exists?
            browser.checkbox(:id => 'frmmandatoryMsgs:tmpAllMsgsRead').set
            if @displayProgress
                puts "\x1B[90mTicked checkbox to never show a message again\x1B[0m\n"
            end
        end
        if browser.input(:id => 'frmmandatoryMsgs:continue_to_your_accounts2').exists?
            browser.input(:id => 'frmmandatoryMsgs:continue_to_your_accounts2').click
            if @displayProgress
                puts "\x1B[90mSuccessfully bypassed (occasional) important information page\x1B[0m\n"
            end
        end
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Halifax\x1B[0m\n"
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
                    cronLog"Halifax: Attempt #{attempt} failed with message: #{e.message}."
                end
            else
                succeeded = true
            ensure
                if succeeded

                    @databaseConnection.query("INSERT INTO bank_account_type_isa (bank_account_id, balance, balance_remaining, date_fetched, date_fetched_string) VALUES (6, #{data['isa']}, #{data['isa_remaining']}, '#{DateTime.now}', '#{DateTime.now}')")
                    @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched, date_fetched_string) VALUES (4, #{data['account_1_balance']}, #{data['account_1_available']}, #{data['account_1_overdraft']}, '#{DateTime.now}', '#{DateTime.now}')")
                    @databaseConnection.query("INSERT INTO bank_account_type_bank_account (bank_account_id, balance, balance_available, balance_overdraft, date_fetched, date_fetched_string) VALUES (5, #{data['account_2_balance']}, #{data['account_2_available']}, #{data['account_2_overdraft']}, '#{DateTime.now}', '#{DateTime.now}')")
                    BankCommon.new.insertTransactions(@databaseConnection, data['isa_transactions'], 6)
                    BankCommon.new.insertTransactions(@databaseConnection, data['account_1_transactions'], 4)
                    BankCommon.new.insertTransactions(@databaseConnection, data['account_2_transactions'], 5)
                    # Check if existing transactions (in last month) still exist
                    objectData = Array[
                        {:bank_account_id => 6, :transactions => data['isa_transactions']},
                        {:bank_account_id => 4, :transactions => data['account_1_transactions']},
                        {:bank_account_id => 5, :transactions => data['account_2_transactions']}
                    ]
                    BankCommon.new.checkIfTransactionStillExist(@databaseConnection, objectData)
                    if showInTerminal
                        puts "\x1B[32mSuccess (Halifax)\x1B[0m"
                    end

                else
                    if attempt >= 5
                        succeeded = true
                        if showInTerminal
                            puts "\x1B[31mSite is either down or there is an error in the Halifax script.\x1B[0m"
                        end
                    end
                end
            end
        end
    end

    def getBalances(showInTerminal = false, browser = self.login)
        sleep(3)
        data = {}

        # ISA
        data['isa'] = browser.div(:class => 'accountBalance', :index => 2).p(:class => 'balance').text.split
        data['isa'] = cleanCurrency(data['isa'][data['isa'].count - 1])
        data['isa_remaining'] = cleanCurrency(browser.div(:class => 'accountBalance', :index => 2).p(:class => 'accountMsg', :index => 1).text)
        browser.link(:title => 'View the latest transactions on your Variable ISA Saver').when_present(5).click
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved balances for \x1B[35mVariable ISA Saver\x1B[0m"
        end
        data_isa = getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView'))
        if browser.input(:type => 'image', :title => 'Previous').exists?
            browser.input(:type => 'image', :title => 'Previous').click
            if browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView').exists?
                data_isa.push(*getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView')))
            end
        end
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved transactions for \x1B[35mVariable ISA Saver\x1B[0m"
        end

        # Ultimate Reward Account
        browser.link(:id => 'lkAccOverView_retail').when_present(5).click
        sleep(1)
        browser.link(:title => 'View the latest transactions on your Ultimate Reward Current Account').when_present(5).click
        data['account_1_balance'] = cleanCurrency(browser.p(:class => 'balance', :index => 0).text)
        data['account_1_available'] = browser.div(:class => 'accountBalance', :index => 0).text.split(':')
        data['account_1_available'] = data['account_1_available'][1].split('[')
        data['account_1_available'] = cleanCurrency(data['account_1_available'][0].strip)
        data['account_1_overdraft'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['account_1_overdraft'] = data['account_1_overdraft'].split
        data['account_1_overdraft'] = cleanCurrency(data['account_1_overdraft'][data['account_1_overdraft'].count - 1])
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved balances for \x1B[33mUltimate Reward Account\x1B[0m"
        end
        data_ultimate_reward = getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView'))
        if browser.input(:type => 'image', :title => 'Previous').exists?
            browser.input(:type => 'image', :title => 'Previous').click
            data_ultimate_reward.push(*getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView')))
        end
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved transactions for \x1B[33mUltimate Reward Account\x1B[0m"
        end

        # Reward Account
        browser.link(:id => 'lkAccOverView_retail').when_present(5).click
        sleep(1)
        browser.link(:title => 'View the latest transactions on your Reward Current Account').when_present(5).click
        data['account_2_balance'] = cleanCurrency(browser.p(:class => 'balance', :index => 0).text)
        data['account_2_available'] = browser.div(:class => 'accountBalance', :index => 0).text.split(':')
        data['account_2_available'] = data['account_2_available'][1].split('[')
        data['account_2_available'] = cleanCurrency(data['account_2_available'][0].strip)
        data['account_2_overdraft'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['account_2_overdraft'] = data['account_2_overdraft'].split
        data['account_2_overdraft'] = cleanCurrency(data['account_2_overdraft'][data['account_2_overdraft'].count - 1])
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved balances for \x1B[33mReward Account\x1B[0m"
        end
        data_reward = getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView'))
        if browser.input(:type => 'image', :title => 'Previous').exists?
            browser.input(:type => 'image', :title => 'Previous').click
            data_reward.push(*getTransactionsFromTable(browser.table(:id => 'pnlgrpStatement:conS1:tblTransactionListView')))
        end
        if showInTerminal
            puts "\x1B[90mSuccessfully retrieved transactions for \x1B[33mReward Account\x1B[0m"
        end

        # Add transactions to final array
        data['isa_transactions'] = data_isa
        data['account_1_transactions'] = data_ultimate_reward
        data['account_2_transactions'] = data_reward

        Array[browser, data]
    end

    def getAllData(showInTerminal = false, browser = self.login)
        # Get balances first
        data = getBalances(showInTerminal, browser)
        data = data[1]
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
                cellCount = cellCount + 1
                if cellCount == 1
                    rowData['date'] = tableCell.text
                elsif cellCount == 2
                    rowData['description'] = tableCell.text
                elsif cellCount == 3
                    rowData['type'] = tableCell.text
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
            newData['balance'] = transaction['balance'].delete(',').to_f
            sanitizedArray << newData
        end
        sanitizedArray
    end

end