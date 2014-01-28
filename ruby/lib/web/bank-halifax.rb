require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class BankHalifax
    include CommandLineReporter

    def initialize(username, password, security, displays = 'single', headless = false, displayProgress = false)
        @username = username
        @password = password
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.halifax-online.co.uk/personal/logon/login.jsp'
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
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Halifax\x1B[0m\n"
        end
        browser
    end

    def getBalances(showInTerminal = false, browser = self.login)
        data = {}
        data['isa'] = browser.div(:class => 'accountBalance', :index => 2).p(:class => 'balance').text.split
        data['isa'] = cleanCurrency(data['isa'][data['isa'].count - 1])
        data['isa_remaining'] = cleanCurrency(browser.div(:class => 'accountBalance', :index => 2).p(:class => 'accountMsg', :index => 1).text)
        browser.link(:title => 'View the latest transactions on your Ultimate Reward Current Account').when_present(5).click
        data['account_1_balance'] = cleanCurrency(browser.p(:class => 'balance', :index => 0).text)
        data['account_1_available'] = browser.div(:class => 'accountBalance', :index => 0).text.split(':')
        data['account_1_available'] = data['account_1_available'][1].split('[')
        data['account_1_available'] = cleanCurrency(data['account_1_available'][0].strip)
        data['account_1_overdraft'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['account_1_overdraft'] = data['account_1_overdraft'].split
        data['account_1_overdraft'] = cleanCurrency(data['account_1_overdraft'][data['account_1_overdraft'].count - 1])
        browser.link(:id => 'lkAccOverView_retail').when_present(5).click
        browser.link(:title => 'View the latest transactions on your Reward Current Account').when_present(5).click
        data['account_2_balance'] = cleanCurrency(browser.p(:class => 'balance', :index => 0).text)
        data['account_2_available'] = browser.div(:class => 'accountBalance', :index => 0).text.split(':')
        data['account_2_available'] = data['account_2_available'][1].split('[')
        data['account_2_available'] = cleanCurrency(data['account_2_available'][0].strip)
        data['account_2_overdraft'] = browser.p(:class => 'accountMsg', :index => 1).text
        data['account_2_overdraft'] = data['account_2_overdraft'].split
        data['account_2_overdraft'] = cleanCurrency(data['account_2_overdraft'][data['account_2_overdraft'].count - 1])
        if showInTerminal
            puts "\n[ #{Rainbow('Halifax').foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('Ultimate Reward', :width => 19, :align => 'right')
                    column('Available Funds', :width => 19, :align => 'right')
                    column('O/D Limit', :width => 19, :align => 'right')
                    column('Reward Account', :width => 19, :align => 'right')
                    column('Available Funds', :width => 19, :align => 'right')
                    column('O/D Limit', :width => 19, :align => 'right')
                    column('Variable ISA Saver', :width => 19, :align => 'right')
                    column('Remaining Allowance', :width => 19, :align => 'right')
                end
                row do
                    column("#{toCurrency(data['account_1_balance'])}", :color => (data['account_1_balance'] < 0) ? 'red' : 'white')
                    column("#{toCurrency(data['account_1_available'])}", :color => (data['account_1_available'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['account_1_overdraft'])}", :color => 'white')
                    column("#{toCurrency(data['account_2_balance'])}", :color => (data['account_2_balance'] < 0) ? 'red' : 'white')
                    column("#{toCurrency(data['account_2_available'])}", :color => (data['account_2_available'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['account_2_overdraft'])}", :color => 'white')
                    column("#{toCurrency(data['isa'])}", :color => (data['isa'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['isa_remaining'])}", :color => 'white')
                end
            end
        end
        Array[browser, data]
    end

end