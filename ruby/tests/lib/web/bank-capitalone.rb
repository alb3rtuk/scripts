require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'

class TestBankCapitalOne < Test::Unit::TestCase

    def testLogin

                capitalOne = BankCapitalOne.new(
            Encrypter.new.decrypt(CapitalOneUsername),
            Encrypter.new.decrypt(CapitalOneSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"
        balances = capitalOne.getBalances
        puts "\n"

        balances[1].each { | key, value |
            assert_equal(key.is_a?(String), true)
            if(key == 'due_date')
                assert_equal(value.is_a?(DateTime), true)
            else
                assert_equal(value.is_a?(Float), true)
            end
        }

    end

end