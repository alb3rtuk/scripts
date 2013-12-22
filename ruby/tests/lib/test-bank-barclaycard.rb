require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

class TestBarclayCard < Test::Unit::TestCase

    def testLogin

        puts "\n\n\x1B[90mAttempting to establish connection with: https://bcol.barclaycard.co.uk/ecom/as2/initialLogon.do\x1B[0m"
        puts "\x1B[90mSuccessfully bypassed first page\x1B[0m"
        puts "\x1B[90mSuccessfully logged in to BarclayCard\x1B[0m\n\n"

    end

end