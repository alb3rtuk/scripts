require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'

class BankExperian
    include CommandLineReporter

    def initialize(username, password, security, displays = 'single', headless = false, displayProgress = false, databaseConnection = nil)
        @username = username
        @password = password
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.creditexpert.co.uk/login/login'
        @databaseConnection = databaseConnection
    end

    def login(browser = getBrowser(@displays, @headless))
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)
        browser.text_field(:name => 'Username', :id => 'Username').set @username
        browser.text_field(:name => 'Password', :id => 'Password').set @password
        browser.button(:class => 'btn btn--a').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end

        charOneLabel = browser.label(:class => 'label-small', :index => 0).when_present(15).text
        charTwoLabel = browser.label(:class => 'label-small', :index => 1).when_present(15).text

        # First letter
        browser.text_field(:name => 'Character1').set getCharAt(charOneLabel.gsub(/[^0-9]/, ''), @security)

        # Second letter (accounts for "last letter" case)
        if charTwoLabel.downcase.strip == 'last letter'
            browser.text_field(:name => 'Character2').set getCharAt(@security.length, @security)
        else
            browser.text_field(:name => 'Character2').set getCharAt(charTwoLabel.gsub(/[^0-9]/, ''), @security)
        end

        browser.button(:class => 'btn btn--a').click
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Experian\x1B[0m\n"
        end
        browser
    end

    def runExtraction(showInTerminal = false)
        attempt = 0
        succeeded = false
        while !succeeded
            begin
                attempt = attempt + 1
                data = getCreditScore(showInTerminal)
                data[0].close
                data = data[1]
            rescue Exception => e
                succeeded = false
                if showInTerminal
                    puts "\x1B[31mAttempt #{attempt} failed with message: \x1B[90m#{e.message}.\x1B[0m"
                end
            else
                succeeded = true
            ensure
                if succeeded
                    @databaseConnection.query("INSERT INTO experian_credit_report (score, score_text, date_fetched, date_fetched_string) VALUES ('#{data['credit_score']}', '#{data['credit_score_text']}', '#{DateTime.now}', '#{DateTime.now}')")
                    if showInTerminal
                        puts "\x1B[32mSuccess (Experian)\x1B[0m"
                    end
                else
                    if attempt >= 1
                        succeeded = true
                        if showInTerminal
                            puts "\x1B[31mSite is either down or there is an error in the Experian script.\x1B[0m"
                        end
                    end
                end
            end
        end
    end

    def getCreditScore(showInTerminal = false, browser = self.login)
        data = {}
        sleep(10)

        #  Get Score
        if browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_MyScoreV31_pnlMyScore1_lblMyScore').exists?
            data['credit_score'] = browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_MyScoreV31_pnlMyScore1_lblMyScore').text
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[36mCredit Score\x1B[0m"
            end
        elsif browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScore').exists?
            data['credit_score'] = browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScore').text
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[36mCredit Score\x1B[0m"
            end
        else
            if showInTerminal
                puts "\x1B[31m ERROR \x1B[0m \x1B[90m Failed to retrieve \x1B[36mCredit Score\x1B[90m, element not found\x1B[0m"
                exit
            end
        end

        #  Get Score Text
        if browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScoreDescription').exists?
            data['credit_score_text'] = browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScoreDescription').text
            if showInTerminal
                puts "\x1B[90mSuccessfully retrieved \x1B[36mCredit Score Text\x1B[0m"
            end
        else
            if showInTerminal
                puts "\x1B[31m ERROR \x1B[0m \x1B[90m Failed to retrieve \x1B[36mCredit Score Text\x1B[90m, element not found\x1B[0m"
                exit
            end
        end

        Array[browser, data]
    end

end