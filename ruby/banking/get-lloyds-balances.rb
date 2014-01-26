require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/encrypter.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'

lloyds = BankLloyds.new(
    Encrypter.new.decrypt(LloydsUsername),
    Encrypter.new.decrypt(LloydsPassword),
    Encrypter.new.decrypt(LloydsSecurity),
    ARGV[0],
    ARGV[1].nil? ? true : false,
    ARGV[1].nil? ? true : false
)

puts "\n"
lloyds.getBalances(true)
puts "\n"
exit