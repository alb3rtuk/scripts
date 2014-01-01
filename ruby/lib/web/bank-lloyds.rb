class BankLloyds
    include CommandLineReporter

    def initialize(username, password, security, displays = 'single', headless = false, displayProgress = false)
        @username = username
        @password = password
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://online.lloydsbank.co.uk/personal/logon/login.jsp'
    end

    # Gets you as far as Lloyds account overview screen & then returns the browser for (possible) further manipulation.
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

        until browser.link(:title => 'View the latest transactions on your Lloyds Account').exists? do
            # Email Confirmation Page
            if browser.input(:id => 'frm2:btnContinue2', :type => 'image').exists?
                browser.input(:id => 'frm2:btnContinue2', :type => 'image').click
                if @displayProgress
                    puts "\x1B[90mSuccessfully bypassed (occasional) email confirmation page\x1B[0m\n"
                end
            end
            # Offers Page
            if browser.link(:title => 'Not right now').exists?
                browser.link(:title => 'Not right now').click
                if @displayProgress
                    puts "\x1B[90mSuccessfully bypassed (occasional) offers page\x1B[0m\n"
                end
            end
        end

        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Lloyds\x1B[0m\n"
        end
        return browser
    end

    def getBalances(showInTerminal = false)
        browser = self.login
        data = {}

        browser.link(:title => 'View the latest transactions on your Lloyds Account').when_present(5).click

        data['account_1_balance'] = browser.p(:class => 'balance', :index => 0).text.delete('£').delete(',').to_f
        data['account_1_available'] = browser.p(:class => 'accountMsg', :index => 0).text
        data['account_1_available'] = data['account_1_available'].split
        data['account_1_available'] = data['account_1_available'][data['account_1_available'].count - 1].delete('£').delete(',').to_f
        data['account_1_overdraft'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['account_1_overdraft'] = data['account_1_overdraft'].split
        data['account_1_overdraft'] = data['account_1_overdraft'][data['account_1_overdraft'].count - 1].delete('£').delete(',').to_f

        browser.link(:id => 'lkAccOverView_retail').when_present(5).click
        browser.link(:title => 'View the latest transactions on your Lloyds Bank Platinum MasterCard').when_present(5).click

        data['cc_balance'] = browser.p(:class => 'balance', :index => 0).text.delete('£').delete(',').to_f
        data['cc_available'] = browser.p(:class => 'accountMsg', :index => 0).text
        data['cc_available'] = data['cc_available'].split(':')
        data['cc_available'] = data['cc_available'][data['cc_available'].count - 1].delete('£').delete(',').to_f
        data['cc_limit'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['cc_limit'] = data['cc_limit'].split(':')
        data['cc_limit'] = data['cc_limit'][data['cc_limit'].count - 1].delete('£').delete(',').to_f
        data['cc_minimum_payment'] = browser.div(:class => 'creditCardStatementDetails clearfix').div(:class => 'numbers').p(:index => 1).text.split
        data['cc_minimum_payment'] = data['cc_minimum_payment'][data['cc_minimum_payment'].count - 1].delete('£').delete(',').to_f
        data['cc_due_date'] = browser.div(:class => 'creditCardStatementDetails clearfix').div(:class => 'payment').p(:index => 0).strong.text
        data['cc_due_date'] = data['cc_due_date'].split(':')
        data['cc_due_date'] = DateTime.strptime(data['cc_due_date'][data['cc_due_date'].count - 1].lstrip.rstrip, '%d %B %Y')

        if showInTerminal
            puts "\n[ #{Rainbow("Lloyds").foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('Platinum MasterCard', :width => 20, :align => 'right')
                    column('Available Funds', :width => 20, :align => 'right')
                    column('Credit Limit', :width => 20, :align => 'right')
                    column('Minimum Payment', :width => 20, :align => 'right')
                    column('Payment Date', :width => 20, :align => 'right')
                    column('Current Account', :width => 20, :align => 'right')
                    column('Available Funds', :width => 20, :align => 'right')
                    column('O/D Limit', :width => 20, :align => 'right')
                end
                row do
                    column("#{toCurrency(0 - data['cc_balance'])}", :color => (data['cc_balance'] > 0) ? 'red' : 'white')
                    column("#{toCurrency(data['cc_available'])}", :color => (data['cc_available'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['cc_limit'])}", :color => 'white')
                    column("#{toCurrency(data['cc_minimum_payment'])}", :color => 'white')
                    column("#{data['cc_due_date'].strftime('%B %d %Y')}", :color => 'white')
                    column("#{toCurrency(data['account_1_balance'])}", :color => (data['account_1_balance'] < 0) ? 'red' : 'white')
                    column("#{toCurrency(data['account_1_available'])}", :color => (data['account_1_available'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['account_1_overdraft'])}", :color => 'white')
                end
            end
        end

        return Array[browser, data]
    end

end