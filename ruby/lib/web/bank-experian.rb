require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class BankExperian
    include CommandLineReporter

    def initialize(username, password, security, displays = 'single', headless = false, displayProgress = false)
        @username = username
        @password = password
        @security = security
        @displays = displays
        @headless = headless
        @displayProgress = displayProgress
        @login_uri = 'https://www.creditexpert.co.uk/MCCLogin.aspx'
    end

    # Gets you as far as Experian account overview screen & then returns the browser for (possible) further manipulation.
    def login(browser = getBrowser(@displays, @headless))
        if @displayProgress
            puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        end
        browser.goto(@login_uri)
        browser.text_field(:name => 'Username', :id => 'Username').set @username
        browser.text_field(:name => 'Password', :id => 'Password').set @password
        browser.input(:type => 'button', :id => 'ensSubmitButton').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        browser.text_field(:name => 'Character1').set getCharAt(browser.div(:class => 'form-label', :index => 0).when_present(15).text.gsub(/[^0-9]/, ''), @security)
        browser.text_field(:name => 'Character2').set getCharAt(browser.div(:class => 'form-label', :index => 1).when_present(15).text.gsub(/[^0-9]/, ''), @security)
        browser.input(:type => 'button', :id => 'ensSubmitButton').click
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Experian\x1B[0m\n"
        end
        browser
    end

    def getCreditInfo(showInTerminal = false, browser = self.login)
        data = {}
        sleep(8)
        if browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_MyScoreV31_pnlMyScore1_lblMyScore').exists?
            data['credit_score'] = browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_MyScoreV31_pnlMyScore1_lblMyScore').text
        elsif browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScore').exists?
            data['credit_score'] = browser.span(:id => 'MCC_ScoreIntelligence_ScoreIntelligence_Dial1_idScoreAttribBox1_MyScoreV31_pnlMyScore1_lblMyScore').text
        else
            data['credit_score'] = 'ERROR'
        end
        if showInTerminal
            puts "\n[ #{Rainbow('Experian').foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('Credit Score', :width => 19, :align => 'right')
                end
                row do
                    column(data['credit_score'], :color => 'magenta')
                end
            end
        end

        Array[browser, data]
    end

end