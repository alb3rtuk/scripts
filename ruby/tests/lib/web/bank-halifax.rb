require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'

class TestBankHalifax < Test::Unit::TestCase

    def testLogin

        crypter = Encrypter.new

        halifax = BankHalifax.new(
            crypter.decrypt(HalifaxUsername),
            crypter.decrypt(HalifaxPassword),
            crypter.decrypt(HalifaxSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"
        data = halifax.getBalances
        puts "\n"

        data[1].each { |key, value|
            assert_equal(key.is_a?(String), true)
            assert_equal(value.is_a?(Float), true)
        }

    end

end