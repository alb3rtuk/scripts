require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

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
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to BarclayCard\x1B[0m\n"
        end
        browser
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
            puts "\n[ #{Rainbow('BarclayCard').foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('BarclayCard Visa', :width => 19, :align => 'right')
                    column('Available Funds', :width => 19, :align => 'right')
                    column('Credit Limit', :width => 19, :align => 'right')
                    column('Minimum Payment', :width => 19, :align => 'right')
                    column('Payment Date', :width => 19, :align => 'right')
                    column('Pending', :width => 19, :align => 'right')
                end
                row do
                    column("#{toCurrency(0 - data['balance'])}", :color => (data['balance'] > 0) ? 'red' : 'white')
                    column("#{toCurrency(data['available_funds'])}", :color => (data['available_funds'] > 0) ? 'white' : 'red')
                    column("#{toCurrency(data['credit_limit'])}", :color => 'white')
                    column("#{toCurrency(data['minimum_payment'])}", :color => 'white')
                    column("#{data['due_date'].strftime('%B %d %Y')}", :color => 'white')
                    ptSign = ''
                    if (data['pending_transactions'] < 0)
                        ptSign = '+'
                        ptColor = 'green'
                    elsif (data['pending_transactions'] > 0)
                        ptColor = 'red'
                    else
                        ptColor = 'white'
                    end
                    column("#{ptSign}#{toCurrency(0 - data['pending_transactions'])}", :color => ptColor)
                end
            end
        end

        Array[browser, data]
    end

    # Pays the amount passed in. Must also pass in browser in a state where it's already at login screen.
    def payBarclayCard(amount, account, browser = self.login)
        verifyInput(Array['halifax', 'natwest'], account)
        if @displayProgress
            puts "\x1B[90mAttempting to pay #{toCurrency(amount)} towards outstanding balance\x1B[0m"
        end
        browser.text_field(:id => 'otherAmount', :name => 'otherAmount', :type => 'text', :class => 'text').set amount
        if account == 'halifax' && browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4462919386484319').exists?
            browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4462919386484319').select
            securityCode = Encrypter.new.decrypt(HalifaxRewardCode)
            accountName = 'HALIFAX REWARD'
            accountCardNumber = '**** **** **** 4319'
        elsif account == 'natwest' && browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4751270014064838').exists?
            browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4751270014064838').select
            securityCode = Encrypter.new.decrypt(NatWestADGoldCode)
            accountName = 'NATWEST AD GOLD'
            accountCardNumber = '**** **** **** 4838'
        else
            abort "Can't find the drop down for selecting the account from which to make payment from. Script aborted."
        end
        browser.input(:type => 'submit', :name => 'makePayment', :id => 'ASCSFn3').click

        if browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).h2(:class => 'titleTo').text.downcase == "you're paying barclaycard" &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataLeft', :index => 0).text.downcase == 'you want to pay' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataRight', :index => 0).text.delete('£') == amount &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataLeft', :index => 1).text.downcase == 'barclaycard account' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataRight', :index => 1).text.downcase == "albert's barclaycard" &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataLeft', :index => 2).text.downcase == 'barclaycard number' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 1).field_set(:index => 0).div(:class => 'rowDataRight', :index => 2).text == '**** **** **** 6004' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'rowDataLeft', :index => 0).text.downcase == 'debit card' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'rowDataRight', :index => 0).text.upcase == accountName &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'rowDataLeft', :index => 1).text.downcase == 'card number' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'rowDataRight', :index => 1).text == accountCardNumber &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).label(:for => 'securityCode').text.downcase == 'card security code' &&
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'row', :index => 0).div(:class => 'field', :index => 0).text_field(:id => 'securityCode', :name => 'cardSecurityNumber', :type => 'text').exists? &&
            browser.input(:type => 'submit', :id => "AS7", :value => 'Confirm').exists?
            if @displayProgress
                puts "\x1B[90mSanity checks passed, now entering 3-digit security code.\x1B[0m"
            end
            browser.div(:id => 'direct_debit').div(:class => 'section', :index => 2).field_set(:index => 0).div(:class => 'row', :index => 0).div(:class => 'field', :index => 0).text_field(:id => 'securityCode', :name => 'cardSecurityNumber', :type => 'text').set securityCode
            browser.input(:type => 'submit', :id => "AS7", :value => 'Confirm').click

            # Bypass NatWest Security
            if account == 'natwest'
                if @displayProgress
                    puts "\x1B[90mAttempting to bypass NatWest Security screen\x1B[0m"
                end
                securityChars = Array.new
                securityMap = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth', 9 => 'ninth', 10 => 'tenth'}
                securityText = browser.frame(:id => 'middle').label(:for => 'Password').text.downcase
                securityMap.each { |key, value|
                    if securityText.include? value
                        securityChars << key
                    end
                }
                count = 0
                securityChars.each { |value|
                    browser.frame(:id => 'middle').text_field(:type => 'password', :id => "Password#{count}").set getCharAt(value, Encrypter.new.decrypt(NatWestADGoldSecurity))
                    count = count + 1
                }
                browser.frame(:id => 'middle').button(:value => 'Submit').click
            else
                if @displayProgress
                    puts "\x1B[90mAttempting to bypass Halifax Security screen\x1B[0m"
                end
            end

            if browser.div(:id => 'direct_debit').div(:class => 'acknowledgement').h2.when_present.text.downcase == "thank you. we're processing your payment."
                if @displayProgress
                    puts "\x1B[90mPayment was successful!\x1B[0m"
                end
            end
            browser
        end
    end

end