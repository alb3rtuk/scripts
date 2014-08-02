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
            puts "\n[ #{Rainbow('CapitalOne').foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('CapitalOne Visa', :width => 19, :align => 'right')
                    column('Available Funds', :width => 19, :align => 'right')
                    column('Credit Limit', :width => 19, :align => 'right')
                    column('Minimum Payment', :width => 19, :align => 'right')
                    column('Payment Date', :width => 19, :align => 'right')
                end
                row do
                    column("#{toCurrency(0 - data['balance'])}", :color => (data['balance'] > 0) ? 'red' : 'white')
                    column("#{toCurrency(data['available_funds'])}", :color => (data['available_funds'] > 0) ? 'white' : 'red')
                    column("#{toCurrency(data['credit_limit'])}", :color => 'white')
                    column("#{toCurrency(data['minimum_payment'])}", :color => 'white')
                    column("#{data['due_date'].strftime('%B %d %Y')}", :color => 'white')
                end
            end
        end
        Array[browser, data]
    end

end