require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/nevil-road-surgery.rb'

class TestNevilRoadSurgery < Test::Unit::TestCase

    def testLogin
        displays = 'single'
        crypter = Encrypter.new
        nrs = NevilRoadSurgery.new(
            crypter.decrypt(NevilRoadUsername),
            crypter.decrypt(NevilRoadPassword)
        )
        browser = nrs.login(displays, true)
        assert_equal(browser.link(:id => '__tab_ctl00_ContentPlaceHolder1_TabContainer1_Panel2').exists?, true)
        puts "\n\n\x1B[90mSuccessfully logged in to Nevil Road Surgery\x1B[0m\n\n"
    end

end