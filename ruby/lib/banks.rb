# Require private config file
if(File.exists?('/Users/Albert/bin/config/privateff.rb'))
    require '/Users/Albert/.secrets/secrets.rb'
else
    abort "/Users/Albert/.secrets/secrets.rb doesn't exist. Can't log in without this file."
end

def openLloyds(displays, headless = false)
    browser = Browser.new((headless) ? 'phantomjs' : 'chrome', displays)
    browser.goto('https://online.lloydsbank.co.uk/personal/logon/login.jsp')
    browser.setTextField(":name => 'frmLogin:strCustomerLogin_userID'").to(Encryptor.new.decrypt(LloydsUsername))
    browser.setTextField(":name => 'frmLogin:strCustomerLogin_pwd'").to(Encryptor.new.decrypt(LloydsPassword))
    browser.tickCheckbox(":name => 'frmLogin:loginRemember'")
    browser.clickInput(":id => 'frmLogin:btnLogin1'")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1'").to("#{Encryptor.new.decrypt(LloydsSecurity)}").toPrefix("&nbsp;")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2'").to("#{Encryptor.new.decrypt(LloydsSecurity)}").toPrefix("&nbsp;")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3'").to("#{Encryptor.new.decrypt(LloydsSecurity)}").toPrefix("&nbsp;")
    browser.clickInput(":id => 'frmentermemorableinformation1:btnContinue'")
    browser.ifExists().clickInput(":id => 'frm2:btnContinue2', :type => 'image'")
    return browser
end

def openHalifax(displays, headless = false)
    browser = Browser.new((headless) ? 'phantomjs' : 'chrome', displays)
    browser.goto('https://www.halifax-online.co.uk/personal/logon/login.jsp')
    browser.setTextField(":name => 'frmLogin:strCustomerLogin_userID'").to(Encryptor.new.decrypt(HalifaxUsername))
    browser.setTextField(":name => 'frmLogin:strCustomerLogin_pwd'").to(Encryptor.new.decrypt(HalifaxPassword))
    browser.tickCheckbox(":name => 'frmLogin:loginRemember'")
    browser.clickInput(":id => 'frmLogin:btnLogin1'")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo1'").to("#{Encryptor.new.decrypt(HalifaxSecurity)}").toPrefix("&nbsp;")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo2'").to("#{Encryptor.new.decrypt(HalifaxSecurity)}").toPrefix("&nbsp;")
    browser.getSecurityForLabel(":for => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3'").setSelectField(":name => 'frmentermemorableinformation1:strEnterMemorableInformation_memInfo3'").to("#{Encryptor.new.decrypt(HalifaxSecurity)}").toPrefix("&nbsp;")
    browser.clickInput(":id => 'frmentermemorableinformation1:btnContinue'")
    browser.ifExists().clickInput(":id => 'frm2:btnContinue', :type => 'image'")
    return browser
end

def openNatWest(displays, headless = false)
    browser = Browser.new((headless) ? 'phantomjs' : 'chrome', displays)
    browser.goto('https://www.nwolb.com/default.aspx')
    browser.frame(":id => 'ctl00_secframe'").setTextField(":name => 'ctl00$mainContent$LI5TABA$DBID_edit'").to(Encryptor.new.decrypt(NatWestUsername))
    browser.frame(":id => 'ctl00_secframe'").tickCheckbox(":id => 'ctl00_mainContent_LI5TABA_LI5CBB'")
    browser.frame(":id => 'ctl00_secframe'").clickInput(":id => 'ctl00_mainContent_LI5TABA_LI5-LBA_button_button'")
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALALabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPEA_edit'").to(Encryptor.new.decrypt(NatWestSecurityTop))
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALBLabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPEB_edit'").to(Encryptor.new.decrypt(NatWestSecurityTop))
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALCLabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPEC_edit'").to(Encryptor.new.decrypt(NatWestSecurityTop))
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALDLabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPED_edit'").to(Encryptor.new.decrypt(NatWestSecurityBottom))
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALELabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPEE_edit'").to(Encryptor.new.decrypt(NatWestSecurityBottom))
    browser.frame(":id => 'ctl00_secframe'").getSecurityForLabel(":id => 'ctl00_mainContent_Tab1_LI6DDALFLabel'").setTextField(":id => 'ctl00_mainContent_Tab1_LI6PPEF_edit'").to(Encryptor.new.decrypt(NatWestSecurityBottom))
    browser.frame(":id => 'ctl00_secframe'").tickCheckbox(":id => 'TimeoutCheckbox-LI6CBA'")
    browser.frame(":id => 'ctl00_secframe'").clickInput(":id => 'ctl00_mainContent_Tab1_next_text_button_button'")
    return browser
end

def openCapitalOne(displays, headless = false)
    browser = Browser.new((headless) ? 'phantomjs' : 'chrome', displays)
    browser.goto('https://www.capitaloneonline.co.uk/CapitalOne_Consumer/Login.do')
    browser.setTextField(":name => 'username'").to(Encryptor.new.decrypt(CapitalOneUsername))
    browser.tickCheckbox(":name => 'rememberMeFlag'")
    browser.getSecurityForCustom("div(:class => 'pass-char').p(:index => 0).text").setTextField(":name => 'password.randomCharacter0'").to(Encryptor.new.decrypt(CapitalOneSecurity))
    browser.getSecurityForCustom("div(:class => 'pass-char').p(:index => 1).text").setTextField(":name => 'password.randomCharacter1'").to(Encryptor.new.decrypt(CapitalOneSecurity))
    browser.getSecurityForCustom("div(:class => 'pass-char').p(:index => 2).text").setTextField(":name => 'password.randomCharacter2'").to(Encryptor.new.decrypt(CapitalOneSecurity))
    browser.clickInput(":type => 'submit', :value => 'SIGN IN'")
    browser.ifExists().clickInput(":type => 'submit', :value => 'CONFIRM EMAIL'")
    return browser
end

def openBarclayCard(displays, headless = false)
    browser = Browser.new((headless) ? 'phantomjs' : 'chrome', displays)
    browser.goto('https://bcol.barclaycard.co.uk/ecom/as2/initialLogon.do')
    browser.setTextField(":name => 'username'").to(Encryptor.new.decrypt(BarclayCardUsername))
    browser.setTextField(:name => 'password').to(Encryptor.new.decrypt(BarclayCardPin))
    browser.tickCheckbox(:name => 'remember')
    browser.clickInput(":type => 'submit', :value => 'Continue'")
    browser.getSecurityForLabel(":for => 'lettera'").setSelectField(":name => 'firstAnswer'").to(Encryptor.new.decrypt(BarclayCardSecurity))
    browser.getSecurityForLabel(":for => 'letterb'").setSelectField(":name => 'secondAnswer'").to(Encryptor.new.decrypt(BarclayCardSecurity))
    browser.clickInput(":type => 'submit', :value => 'Log in'")
    return browser
end