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
        browser.text_field(:name => 'loginUser:txtUsername:ECDTextBox', :id => 'loginUser_txtUsername_ECDTextBox').set @username
        browser.text_field(:name => 'loginUser:txtPassword:ECDTextBox', :id => 'loginUser_txtPassword_ECDTextBox').set @password
        browser.input(:type => 'image', :name => 'loginUser:ibtnEnter', :id => 'loginUser_ibtnEnter').click
        if @displayProgress
            puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        end
        browser.text_field(:name => 'loginUserMemorableWord:SecurityQuestionUK1_SecurityAnswer1_ECDTextBox').set getCharAt(browser.span(:id => 'loginUserMemorableWord_SecurityQuestionLetter1').text.gsub(/[^0-9]/, ''), @security)
        browser.text_field(:name => 'loginUserMemorableWord:SecurityQuestionUK1_SecurityAnswer2_ECDTextBox').set getCharAt(browser.span(:id => 'loginUserMemorableWord_SecurityQuestionLetter2').text.gsub(/[^0-9]/, ''), @security)
        browser.input(:type => 'image', :name => 'loginUserMemorableWord:ibtnEnter', :id => 'loginUserMemorableWord_ibtnEnter').click
        if @displayProgress
            puts "\x1B[90mSuccessfully logged in to Experian\x1B[0m\n"
        end
        browser
    end

    def getCreditInfo(showInTerminal = false, browser = self.login)
        data = {}
        data['data'] = browser.div(:class => 'panelSummary', :index => 0).p(:class => 'figure', :index => 0).text.delete('£').delete(',').to_f

        if showInTerminal
            puts "\n[ #{Rainbow('Experian Credit Info').foreground('#ff008a')} ]"
            table(:border => true) do
                row do
                    column('data', :width => 19, :align => 'right')
                end
                row do
                    column("data", :color => 'white')
                end
            end
        end

        Array[browser, data]
    end

end