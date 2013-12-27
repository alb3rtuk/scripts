require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

class TestBankNatWest < Test::Unit::TestCase

    def testLogin

        crypter = Encrypter.new

        natWest = BankNatWest.new(
            crypter.decrypt(NatWestUsername),
            crypter.decrypt(NatWestSecurityTop),
            crypter.decrypt(NatWestSecurityBottom),
            'single',
            true,
            true
        )

        puts "\n\n"
        data = natWest.getBalances
        puts "\n"

        browser = data[0]
        balances = data[1]

        f = 'ctl00_secframe';
        assert_equal(browser.frame(:id => f).tr(:id => 'Account_A412AD6062AE989A9FCDAEB7D9ED8A594808AC87').exists?, true)
        assert_equal(browser.frame(:id => f).tr(:id => 'Account_CE99D6FF6219B59BB28B6A42825D98D60B92326C').exists?, true)
        assert_equal(browser.frame(:id => f).tr(:id => 'Account_FAB7EFB59260BED0F1081E761570BF4227C37E6B').exists?, true)

        balances.each { |key, value|
            assert_equal(key.is_a?(String), true)
            assert_equal(value.is_a?(Float), true)
        }

    end

end