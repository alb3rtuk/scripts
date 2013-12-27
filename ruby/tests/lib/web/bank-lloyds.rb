require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'

class TestBankLloyds < Test::Unit::TestCase

    def testLogin

        crypter = Encrypter.new

        lloyds = BankLloyds.new(
            crypter.decrypt(LloydsUsername),
            crypter.decrypt(LloydsPassword),
            crypter.decrypt(LloydsSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"
        data = lloyds.getBalances
        puts "\n"

        data[1].each { | key, value |
            assert_equal(key.is_a?(String), true)
            if(key == 'cc_due_date')
                assert_equal(value.is_a?(DateTime), true)
            else
                assert_equal(value.is_a?(Float), true)
            end
        }

    end

end