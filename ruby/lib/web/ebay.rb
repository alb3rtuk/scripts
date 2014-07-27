class Ebay

    def initialize(username, password)
        @username = username
        @password = password
    end

    def login(displays, headless = false)
        browser = getBrowser(displays, headless)
        browser.goto('https://signin.ebay.co.uk/ws/eBayISAPI.dll?SignIn')
        browser.text_field(:name => 'userid').set @username
        browser.text_field(:name => 'pass').set @password
        browser.input(:type => 'submit', :name => 'sgnBt').click
        browser
    end

    def getOrder(browser, transid, itemid)
        browser.goto("http://k2b-bulk.ebay.co.uk/ws/eBayISAPI.dll?EditSalesRecord&transid=#{transid}&itemid=#{itemid}")
        browser
    end

end