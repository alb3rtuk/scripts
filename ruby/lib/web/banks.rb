# Require private config file
configFile = '/Users/Albert/bin/config/private.rb'
if(File.exists?(configFile))
    require configFile
else
    abort "#{configFile} exist. Can't log in without this file."
end

# Class that contains methods which log into all the bank accounts.
class Banks

    # Gets you as far as NatWest account overview screen & then returns the browser for (possible) further manipulation.
    def openNatWest(username, security_top, security_bottom, displays, headless = false)

        f = 'ctl00_secframe'

        browser = getBrowser((headless) ? 'phantomjs' : 'chrome', displays)
        browser.goto('https://www.nwolb.com/default.aspx')
        browser.frame(:id => f).text_field(:name => 'ctl00$mainContent$LI5TABA$DBID_edit').set username
        browser.frame(:id => f).checkbox(:id => 'ctl00_mainContent_LI5TABA_LI5CBB').set
        browser.frame(:id => f).input(:id => 'ctl00_mainContent_LI5TABA_LI5-LBA_button_button').click
        
        char1 = getCharAt(browser.frame(:id => f).label(:id => 'ctl00_mainContent_Tab1_LI6DDALALabel').text.scan(/\\d/).join(''), security_top)

        puts char1
        exit
        browser.frame(:id => f).select_list(:id => 'ctl00_mainContent_Tab1_LI6PPEA_edit').option(char1).select
        browser.frame(:id => f)
        browser.frame(:id => f)
        browser.frame(:id => f)
        browser.frame(:id => f)
        browser.frame(:id => f)


        return browser
    end

end