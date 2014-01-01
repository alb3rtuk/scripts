require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'

class TestBankBarclayCard < Test::Unit::TestCase

    def testLogin

                barclayCard = BankBarclayCard.new(
            Encrypter.new.decrypt(BarclayCardUsername),
            Encrypter.new.decrypt(BarclayCardPin),
            Encrypter.new.decrypt(BarclayCardSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"
        data = barclayCard.getBalances
        puts "\n"

        browser = data[0]
        assert_equal()

        data[1].each { | key, value |
            assert_equal(key.is_a?(String), true)
            if(key == 'due_date')
                assert_equal(value.is_a?(DateTime), true)
            else
                assert_equal(value.is_a?(Float), true)
            end
        }

    end

end