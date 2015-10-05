require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')

class NevilRoadSurgery

    def initialize(username, password)
        @username = username
        @password = password
        @cNumbers = Array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end

    def login(displays, headless = false)
        browser = getBrowser(displays, headless)
        browser.goto('https://www.mysurgerywebsite.co.uk/secure/prescriptionsl.aspx?p=l81107')
        browser.text_field(:name => 'ctl00$ContentPlaceHolder1$logon_email').set @username
        browser.text_field(:name => 'ctl00$ContentPlaceHolder1$logon_password').set @password
        browser.input(:name => 'ctl00$ContentPlaceHolder1$buttonOK').click
        browser
    end

    def orderAsthma(displays, headless = false)
        browser = self.login(displays, headless)
        browser.link(:id => '__tab_ctl00_ContentPlaceHolder1_TabContainer1_Panel2').click

        # Remove this when I want my inhalers automatically ordered again :)
        cronLog('Nevil Road Surgery script terminated early until further notice!')
        exit

        foundIt = false
        @cNumbers.each { |x|
            if (browser.text_field(:id => "ctl00_ContentPlaceHolder1_TabContainer1_Panel2_item#{x}").value == "Ventolin (Blue Inhaler) x 2")
                browser.checkbox(:id => "ctl00_ContentPlaceHolder1_TabContainer1_Panel2_CheckBox#{x}").set
                foundIt = true
                break
            else
                browser.checkbox(:id => "ctl00_ContentPlaceHolder1_TabContainer1_Panel2_CheckBox#{x}").clear
            end
        }
        # If Ventolin isn't found, exit the script.
        if foundIt == false
            msg = "Order Asthma script aborted because the text 'Ventolin (Blue Inhaler) x 2' couldn't be found for the clickable checkboxes."
            if(headless == false)
                abort msg
            else
                log(msg)
                exit
            end
        end
        browser.link(:id => '__tab_ctl00_ContentPlaceHolder1_TabContainer1_Panel3').click
        browser.select_list(:id => 'ctl00_ContentPlaceHolder1_TabContainer1_Panel3_emailReminder').option(:value => '1').select
        browser.checkbox(:id => 'ctl00_ContentPlaceHolder1_TabContainer1_Panel3_confirmation').set
        browser.input(:name => 'ctl00$ContentPlaceHolder1$TabContainer1$Panel3$buttonSend').click
        cronLog('Asthma inhalers have been successfully ordered. Ready for collection at Soods Chemist in 2-3 days.')
        return browser
    end

end