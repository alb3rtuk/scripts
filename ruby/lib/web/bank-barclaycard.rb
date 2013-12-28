configFile = '/Users/Albert/bin/config/private.rb'
if (File.exists?(configFile))
    require configFile
else
    abort "#{configFile} exist. Can't log in without this file."
end

class BankBarclayCard
    include CommandLineReporter

    def initialize(username, pin, security, displays = 'single', headless = false, displayProgress = false)
        @username = username
        @pin = pin
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://bcol.barclaycard.co.uk/ecom/as2/initialLogon.do'
    end

    # Gets you as far as BarclayCard account overview screen & then returns the browser for (possible) further manipulation.
    def login
        browser = getBrowser(@displays, @headless)
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
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to BarclayCard\x1B[0m\n"
        end
        return browser
    end

    def getBalances(showInTerminal = false)
        browser = self.login
        data = {}

        data['balance'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 0).text.delete('£').delete(',').to_f
        data['available_funds'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 2).text.delete('£').delete(',').to_f
        data['credit_limit'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 3).text.delete('£').delete(',').to_f
        data['minimum_payment'] = browser.div(:class => 'panelSummary', :index => 1).p(:class => 'figure', :index => 2).text.delete('£').delete(',').to_f
        data['due_date'] = DateTime.strptime(browser.div(:class => 'panelSummary', :index => 1).p(:class => 'figure', :index => 3).text, '%d %b %y')
        data['pending_transactions'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 1).text.delete('£').delete(',').to_f

        if showInTerminal
            puts "\n[ #{Rainbow("BarclayCard").foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('BarclayCard Visa', :width => 20, :align => 'right')
                    column('Available Funds', :width => 20, :align => 'right')
                    column('Credit Limit', :width => 20, :align => 'right')
                    column('Minimum Payment', :width => 20, :align => 'right')
                    column('Payment Date', :width => 20, :align => 'right')
                    column('Pending Transactions', :width => 20, :align => 'right')
                end
                row do
                    column("#{toCurrency(0 - data['balance'])}", :color => (data['balance'] > 0) ? 'red' : 'white')
                    column("#{toCurrency(data['available_funds'])}", :color => (data['available_funds'] > 0) ? 'green' : 'white')
                    column("#{toCurrency(data['credit_limit'])}", :color => 'white')
                    column("#{toCurrency(data['minimum_payment'])}", :color => 'white')
                    column("#{data['due_date'].strftime('%B %d %Y')}", :color => 'white')
                    column("#{toCurrency(0 - data['pending_transactions'])}", :color => (data['pending_transactions'] > 0) ? 'red' : 'white')
                end
            end
        end

        return Array[browser, data]
    end

end