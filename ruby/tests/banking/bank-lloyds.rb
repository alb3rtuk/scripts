require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'

class TestBankLloyds < Test::Unit::TestCase

    def testLogin

        lloyds = BankLloyds.new(
            Encrypter.new.decrypt(LloydsUsername),
            Encrypter.new.decrypt(LloydsPassword),
            Encrypter.new.decrypt(LloydsSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"

        browser = lloyds.login

        # Test for payment elements
        assert_equal(true, browser.link(:id => 'frm1:lstAccLst:1:accountOptions1:lstAccFuncs:0:lkAccFuncs').when_present(5).exists?)

        balances = lloyds.getBalances(false, browser)
        balances[1].each { |key, value|
            assert_equal(key.is_a?(String), true)
            if (key == 'cc_due_date')
                assert_equal(value.is_a?(DateTime), true)
            else
                assert_equal(value.is_a?(Float), true)
            end
        }

        puts "\n"

    end

end