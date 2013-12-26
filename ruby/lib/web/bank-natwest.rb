# Require private config file
configFile = '/Users/Albert/bin/config/private.rb'
if(File.exists?(configFile))
    require configFile
else
    abort "#{configFile} exist. Can't log in without this file."
end

class BankNatWest

    def initialize(username, security_top, security_bottom, displays = 'single', headless = false)
        @useranme = username
        @security_top = security_top
        @security_bottom = security_bottom
        @displays = displays
        @headless = headless
        @login_uri = 'https://www.nwolb.com/default.aspx'
    end

    # Gets you as far as NatWest account overview screen & then returns the browser for (possible) further manipulation.
    def login()
        f = 'ctl00_secframe'
        browser = getBrowser(@displays, @headless)
        puts "\x1B[90mAttempting to establish connection with: #{@login_uri}\x1B[0m"
        browser.goto(@login_uri)
        browser.frame(:id => f).text_field(:name => 'ctl00$mainContent$LI5TABA$DBID_edit').set @useranme
        browser.frame(:id => f).checkbox(:id => 'ctl00_mainContent_LI5TABA_LI5CBB').set
        browser.frame(:id => f).input(:id => 'ctl00_mainContent_LI5TABA_LI5-LBA_button_button').click
        puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEA_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALALabel').text.gsub(/[^0-9]/,''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEB_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALBLabel').text.gsub(/[^0-9]/,''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEC_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALCLabel').text.gsub(/[^0-9]/,''), @security_top)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPED_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALDLabel').text.gsub(/[^0-9]/,''), @security_bottom)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEE_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALELabel').text.gsub(/[^0-9]/,''), @security_bottom)
        browser.frame(:id => f).text_field(:id => 'ctl00_mainContent_Tab1_LI6PPEF_edit').set getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALFLabel').text.gsub(/[^0-9]/,''), @security_bottom)
        browser.frame(:id => f).checkbox(:id => 'TimeoutCheckbox-LI6CBA').set
        browser.frame(:id => f).input(:id => 'ctl00_mainContent_Tab1_next_text_button_button').click
        puts "\x1B[90mSuccessfully logged in to NatWest\x1B[0m\n"
        return browser
    end

end