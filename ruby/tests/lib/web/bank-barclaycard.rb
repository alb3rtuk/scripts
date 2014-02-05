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
        balances = barclayCard.getBalances
        puts "\n"

        browser = balances[0]

        # Test for payment elements
        assert_equal(true, browser.text_field(:id => 'otherAmount', :name => 'otherAmount', :type => 'text', :class => 'text').exists?)
        assert_equal(true, browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4462919386484319').exists?)
        assert_equal(true, browser.select_list(:id => 'ASCSPn2', :name => 'accountSelect').option(:value => '4751270014064838').exists?)
        assert_equal(true, browser.input(:type => 'submit', :name => 'makePayment', :id => 'ASCSFn3').exists?)

        balances[1].each { |key, value|
            assert_equal(key.is_a?(String), true)
            if (key == 'due_date')
                assert_equal(value.is_a?(DateTime), true)
            else
                assert_equal(value.is_a?(Float), true)
            end
        }

    end

end