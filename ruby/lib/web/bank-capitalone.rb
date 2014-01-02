require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class BankCapitalOne
    include CommandLineReporter

    def initialize(username, security, displays = 'single', headless = false, displayProgress = false)
        @username = username
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.capitaloneonline.co.uk/CapitalOne_Consumer/Login.do'
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
        return browser
    end

    def getBalances(showInTerminal = false, browser = self.login)
        data = {}
        data['balance'] = browser.td(:text, /Current balance/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['available_funds'] = browser.td(:text, /Available to spend/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['credit_limit'] = browser.td(:text, /Credit limit/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['minimum_payment'] = browser.td(:text, /Minimum payment/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['due_date'] = DateTime.strptime(browser.td(:text, /Payment due date/).parent.cell(:index => 1).text, '%d-%m-%Y')
        if showInTerminal
            puts "\n[ #{Rainbow("CapitalOne").foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('CapitalOne Visa', :width => 20, :align => 'right')
                    column('Available Funds', :width => 20, :align => 'right')
                    column('Credit Limit', :width => 20, :align => 'right')
                    column('Minimum Payment', :width => 20, :align => 'right')
                    column('Payment Date', :width => 20, :align => 'right')
                end
                row do
                    column("#{toCurrency(0 - data['balance'])}", :color => (data['balance'] > 0) ? 'red' : 'white')
                    column("#{toCurrency(data['available_funds'])}", :color => (data['available_funds'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['credit_limit'])}", :color => 'white')
                    column("#{toCurrency(data['minimum_payment'])}", :color => 'white')
                    column("#{data['due_date'].strftime('%B %d %Y')}", :color => 'white')
                end
            end
        end
        Array[browser, data]
    end

    # Pays the amount passed in. Must also pass in browser in a state where it's already at login screen.
    def payCapitalOne(amount, account, browser = self.login)
        verifyInput(Array['natwest'], account)
        if @displayProgress
            puts "\x1B[90mAttempting to pay #{toCurrency(amount)} towards outstanding balance\x1B[0m"
        end
        browser.input(:type => 'submit', :value => 'MAKE PAYMENT', :class => 'btn').click
        browser.input(:type => 'submit', :value => 'PAY BY DEBIT CARD', :class => 'btn').click
        browser.input(:type => 'radio', :value => 'OtherAmount', :name => 'paymentAmountFlag', :id => 'radio-check').click

        # 1st sanity check
        if browser.radio(:name => 'selectedPaymentAccountID', :value => '2675167').checked?
            if @displayProgress
                puts "\x1B[90mPassed sanity check #1. Entering amount + 3-digit security code\x1B[0m"
            end
            browser.text_field(:name => 'paymentAmount', :id => 'radio-select').set amount
            browser.text_field(:name => 'cardVerificationCode').set Encrypter.new.decrypt(NatWestADGoldCode)
            browser.input(:type => 'submit', :value => 'MAKE THIS PAYMENT', :class => 'btn').click
        else
            puts "Capital one sanity check #1 failed. Script aborted and no payment was made!\n"
            puts browser.radio(:name => 'selectedPaymentAccountID', :value => '2675167').checked?
            puts
            exit 1
        end

        # 2nd sanity check
        if browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 0).text == 'NATWEST AD GOLD' &&
            browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 1).text == '4838' &&
            browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 2).text == 'MR ALBERT RANNETSPERGER' &&
            browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 3).text == '10/15' &&
            browser.tr(:class => 'table-categories', :index => 1).td(:index => 0).text == 'Payment amount' &&
            browser.tr(:class => 'table-categories', :index => 1).td(:index => 1).text.delete('£') == amount
            if @displayProgress
                puts "\x1B[90mPassed sanity check #2. Everything still seems OK\x1B[0m"
            end
            browser.input(:type => 'submit', :value => 'CONFIRM DEBIT CARD PAYMENT', :class => 'btn').click
        else
            puts "Capital one sanity check #2 failed. Script aborted and no payment was made!\n"
            puts browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 0).text
            puts browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 1).text
            puts browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 2).text
            puts browser.tr(:class => 'table-categories', :index => 0).parent.tr(:index => 1).td(:index => 3).text
            puts browser.tr(:class => 'table-categories', :index => 1).td(:index => 0).text
            puts browser.tr(:class => 'table-categories', :index => 1).td(:index => 1).text
            puts
            exit 1
        end

        # Bypass NatWest Security
        if @displayProgress
            puts "\x1B[90mAttempting to bypass NatWest Security screen\x1B[0m"
        end
        securityChars = Array.new
        securityMap = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth', 9 => 'ninth', 10 => 'tenth'}
        securityText = browser.frame(:src => 'CreateIframe.do').label(:for => 'Password').text.downcase
        securityMap.each { |key, value|
            if securityText.include? value
                securityChars << key
            end
        }
        count = 0
        securityChars.each { |value|
            browser.frame(:src => 'CreateIframe.do').text_field(:type => 'password', :id => "Password#{count}").set getCharAt(value, Encrypter.new.decrypt(NatWestADGoldSecurity))
            count = count + 1
        }
        browser.frame(:src => 'CreateIframe.do').button(:value => 'Submit').click

        # Confirm that everything went OK
        if browser.tr(:class => 'table-categories', :index => 1).td(:index => 0).text == 'Payment amount' &&
            browser.tr(:class => 'table-categories', :index => 1).td(:index => 1).text.delete('£') == amount &&
            browser.tr(:class => 'table-categories', :index => 2).td(:index => 0).text == 'Payment date' &&
            browser.tr(:class => 'table-categories', :index => 3).td(:index => 0).text == 'Status' &&
            browser.tr(:class => 'table-categories', :index => 3).td(:index => 1).text == 'Approved' &&
            browser.tr(:class => 'table-categories', :index => 4).td(:index => 0).text == 'Reference number'
            ref = browser.tr(:class => 'table-categories', :index => 4).td(:index => 1).text
            if @displayProgress
                puts "\x1B[90mPayment was successful! Your reference number for this payment is: \x1B[0m#{ref}"
                puts "\x1B[90mYou should receive an email from CapitalOne very shortly \x1B[0m"
            end
        else
            abort "Something went wrong. The confirmation screen was reached but the checks didn't pass. This doesn't necessarily mean the payment wasn't made, possibly some of the elements on the page were updated."
        end
        browser
    end

end