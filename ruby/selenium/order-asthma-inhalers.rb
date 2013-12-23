require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

displays = ARGV[0]
crypter = Encrypter.new
checkboxNumbers = Array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

browser = getBrowser('chrome', displays)
browser.goto('https://www.mysurgerywebsite.co.uk/secure/prescriptionsl.aspx?p=l81107')
browser.text_field(:name => 'ctl00$ContentPlaceHolder1$logon_email').set crypter.decrypt(NevilRoadUsername)
browser.text_field(:name => 'ctl00$ContentPlaceHolder1$logon_password').set crypter.decrypt(NevilRoadPassword)
browser.input(:name => 'ctl00$ContentPlaceHolder1$buttonOK').click
browser.link(:id => '__tab_ctl00_ContentPlaceHolder1_TabContainer1_Panel2').click

foundIt = false

checkboxNumbers.each { |x|
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
    exit
end

browser.link(:id => '__tab_ctl00_ContentPlaceHolder1_TabContainer1_Panel3').click
browser.select_list(:id => 'ctl00_ContentPlaceHolder1_TabContainer1_Panel3_emailReminder').option(:value => '1').select
browser.checkbox(:id => 'ctl00_ContentPlaceHolder1_TabContainer1_Panel3_confirmation').set