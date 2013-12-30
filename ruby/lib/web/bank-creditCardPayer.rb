require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

# Ruby script helper to pay credit cards from the command line.
class BankCreditCardPayer

    # Tell the class what banks & credit cards to initiallize.
    def initialize(creditCard, bankAccounts)
        verifyInput(Array['barclaycard', 'capitalone', 'lloyds'], creditCard)
        bankAccounts.each do | bankAccount |
            verifyInput(Array['natwest', 'halifax', 'lloyds'], bankAccount)
        end

        crypter = Encrypter.new

        @outstanding_balance = 0
        @minimum_payment = 0
        @due_date = 0

        @payment_accounts = Array.new

        puts "\n"

        # Get Credit Cards
        if creditCard == 'barclaycard'
            @barclayCard = BankBarclayCard.new(crypter.decrypt(BarclayCardUsername), crypter.decrypt(BarclayCardPin), crypter.decrypt(BarclayCardSecurity), 'single', true, true)
            @barclayCard = @barclayCard.getBalances(false)
            @outstanding_balance = @barclayCard[1]['balance']
            @minimum_payment = @barclayCard[1]['minimum_payment']
            @due_date = @barclayCard[1]['due_date']
        elsif creditCard == 'capitalone'
            @capitalOne = BankCapitalOne.new(crypter.decrypt(CapitalOneUsername), crypter.decrypt(CapitalOneSecurity), 'single', true, true)
            @capitalOne = @capitalOne.getBalances(false)
            @outstanding_balance = @capitalOne[1]['balance']
            @minimum_payment = @capitalOne[1]['minimum_payment']
            @due_date = @capitalOne[1]['due_date']
        elsif creditCard == 'lloyds'
            @lloyds = BankLloyds.new(crypter.decrypt(LloydsUsername), crypter.decrypt(LloydsPassword), crypter.decrypt(LloydsSecurity), 'single', true, true)
            @lloyds = @lloyds.getBalances(false)
            @outstanding_balance = @lloyds[1]['cc_balance']
            @minimum_payment = @lloyds[1]['cc_minimum_payment']
            @due_date = @lloyds[1]['cc_due_date']
        end

        self.displayOutstandingBalance

        # Get Bank Account(s)
        bankAccounts.each do | bankAccount |
            payment_account = {}

            if bankAccount == 'lloyds'
                if !defined? @lloyds
                    @lloyds = BankLloyds.new(crypter.decrypt(LloydsUsername), crypter.decrypt(LloydsPassword), crypter.decrypt(LloydsSecurity), 'single', true, true)
                    @lloyds = @lloyds.getBalances(false)
                end
                payment_account['account_id'] = 'lloyds'
                payment_account['account_name'] = 'Lloyds Current Account'
                payment_account['balance'] = @lloyds[1]['account_1_balance']
                payment_account['available'] = @lloyds[1]['account_1_available']
            elsif bankAccount == 'halifax'
                @halifax = BankHalifax.new(crypter.decrypt(HalifaxUsername), crypter.decrypt(HalifaxPassword), crypter.decrypt(HalifaxSecurity), 'single', true, true)
                @halifax = @halifax.getBalances(false)
                payment_account['account_id'] = 'halifax'
                payment_account['account_name'] = 'Halifax Reward Account'
                payment_account['balance'] = @lloyds[1]['account_2_balance']
                payment_account['available'] = @lloyds[1]['account_2_available']
            elsif bankAccount == 'natwest'
                @natwest = BankNatWest.new(crypter.decrypt(NatWestUsername), crypter.decrypt(NatWestSecurityTop), crypter.decrypt(NatWestSecurityBottom), 'single', true, true)
                @natwest = @natwest.getBalances(false)
                payment_account['account_id'] = 'natwest'
                payment_account['account_name'] = 'NatWest Advantage Gold'
                payment_account['balance'] = @lloyds[1]['advantage_gold']
                payment_account['available'] = @lloyds[1]['advantage_gold']
            end
            @payment_accounts.push(payment_account)
        end

    end

    # Display the outstanding balance
    def displayOutstandingBalance
        puts "\n"
        if @outstanding_balance > 0
            puts "Outstanding Balance        : \x1B[31m#{toCurrency(@outstanding_balance).to_s.rjust(11)}\x1B[0m"
        else
            puts "Outstanding Balance        : #{toCurrency(@outstanding_balance).to_s.rjust(11)}"
        end

        if @minimum_payment
            puts "Minimum Payment            : \x1B[31m#{toCurrency(@minimum_payment).to_s.rjust(11)}\x1B[0m"
        else
            puts "Minimum Payment            : #{toCurrency(@minimum_payment).to_s.rjust(11)}"
        end
        puts "Due Date                   : \x1B[90m#{@due_date.strftime('%d-%m-%y').to_s.rjust(11)} (in #{diffBetweenDatesInDays(@due_date.strftime('%y-%m-%d'))} days)\x1B[0m"
    end

end