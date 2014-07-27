class IConsign

    def initialize(username, password)
        @username = username
        @password = password
    end

    def login(displays, headless = false)
        browser = getBrowser(displays, headless)
        browser.goto('https://iconsign.ukmail.com/IConsign/Index.aspx?Action=sessionexpired')
        sleep(3)
        browser.text_field(:name => 'txtUsername').set @username
        browser.text_field(:name => 'txtPassword').set @password
        browser.input(:type => 'submit', :name => 'btnLogin').click
        browser
    end

    def processOrder(browser, name, address1, address2, city, county, postcode, phone, email, reference, items, weight, userID)
        browser.text_field(:name => 'ctl00$mainContent$contact').set name
        browser.text_field(:name => 'ctl00$mainContent$customerRef').set userID
        browser.text_field(:name => 'ctl00$mainContent$alternativeRef').set reference
        browser.text_field(:name => 'ctl00$mainContent$telephone').set phone
        browser.text_field(:name => 'ctl00$mainContent$emailAddress').set email
        browser.text_field(:name => 'ctl00$mainContent$postCode').set postcode
        browser.checkbox(:id => 'ctl00_mainContent_signatureOptional').click
        sleep(1)
        browser.link(:id => 'mb_close_link').click
        browser.text_field(:name => 'ctl00$mainContent$address1').set address1
        browser.text_field(:name => 'ctl00$mainContent$address2').set address2
        browser.text_field(:name => 'ctl00$mainContent$postalTown').set city
        browser.text_field(:name => 'ctl00$mainContent$county').set county
        browser.text_field(:name => 'ctl00$mainContent$domesticItems').set items
        browser.text_field(:name => 'ctl00$mainContent$domesticWeight').set weight
        browser.input(:type => 'radio', :id => 'ctl00_mainContent_preDelEmail').click
        browser
    end

end