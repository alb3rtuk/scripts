require 'test/unit'
require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-experian.rb'

class TestBankExperian < Test::Unit::TestCase

    def testLogin

        experian = BankExperian.new(
            Encrypter.new.decrypt(ExperianUsername),
            Encrypter.new.decrypt(ExperianPassword),
            Encrypter.new.decrypt(ExperianSecurity),
            'single',
            true,
            true
        )

        puts "\n\n"
        experian = experian.getCreditInfo
        puts "\n"

        data = experian[1]

        assert_equal(isWholeNumber(data['credit_score']), true)

    end

end