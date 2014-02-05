require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-experian.rb'

experian = BankExperian.new(
    Encrypter.new.decrypt(ExperianUsername),
    Encrypter.new.decrypt(ExperianPassword),
    Encrypter.new.decrypt(ExperianSecurity),
    'single',
    true,
    true
)

puts "\n"
experian.getCreditInfo(true)
puts "\n"
exit