configFile = '/Users/Albert/bin/config/private.rb'
if (File.exists?(configFile))
    require configFile
else
    abort "#{configFile} exist. Can't log in without this file."
end

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
    def login
        browser = getBrowser(@displays, @headless)
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

    def getBalances(showInTerminal = false)
        browser = self.login
        data = {}
        data['current_balance'] = browser.td(:text, /Current balance/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['available_credit'] = browser.td(:text, /Available to spend/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['credit_limit'] = browser.td(:text, /Credit limit/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['minimum_payment'] = browser.td(:text, /Minimum payment/).parent.cell(:index => 1).text.delete('£').delete(',').to_f
        data['due_date'] = DateTime.strptime(browser.td(:text, /Payment due date/).parent.cell(:index => 1).text, '%d-%m-%Y')

        if showInTerminal
            puts "\n[ #{Rainbow("CapitalOne").foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('Outstanding Balance', :width => 20, :align => 'right')
                    column('Available Credit', :width => 20, :align => 'right')
                    column('Credit Limit', :width => 20, :align => 'right')
                    column('Minimum Payment', :width => 20, :align => 'right')
                    column('Payment Due', :width => 20, :align => 'right')
                end
                row do
                    column("-£#{toCurrency(data['current_balance'])}", :color => 'red')
                    column("£#{toCurrency(data['available_credit'])}", :color => 'green')
                    column("£#{toCurrency(data['credit_limit'])}", :color => 'green')
                    column("£#{toCurrency(data['minimum_payment'])}", :color => 'green')
                    column("#{data['due_date'].strftime('%d %b %Y')}", :color => 'white')
                end
            end
        end

        return Array[browser, data]
    end

end