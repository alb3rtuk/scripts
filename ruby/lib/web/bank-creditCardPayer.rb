require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-barclaycard.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-capitalone.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-halifax.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-lloyds.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/web/bank-natwest.rb'

# Ruby script helper to pay credit cards from the command line.
class BankCreditCardPayer

    # Tell the class what banks & credit cards to initiallize.
    def initialize(creditCard, bankAccounts, displays = 'single', headless = true, displayProgress = true)
        verifyInput(Array['barclaycard', 'capitalone', 'lloyds'], creditCard)
        bankAccounts.each do |bankAccount|
            verifyInput(Array['natwest', 'halifax', 'lloyds'], bankAccount)
        end

        @outstanding_balance = 0
        @minimum_payment = 0
        @due_date = 0
        @payment_accounts = Array.new
        @payment_map = {}
        @chosenAccount = 0
        @chosenAmount = 0

        puts "\n"

        #Get Credit Cards
        if creditCard == 'barclaycard'
            @barclayCard = BankBarclayCard.new(
                Encrypter.new.decrypt(BarclayCardUsername),
                Encrypter.new.decrypt(BarclayCardPin),
                Encrypter.new.decrypt(BarclayCardSecurity),
                displays,
                headless,
                displayProgress
            )
            @barclayCardResponse = @barclayCard.getBalances(false)
            @outstanding_balance = @barclayCardResponse[1]['balance']
            @minimum_payment = @barclayCardResponse[1]['minimum_payment']
            @due_date = @barclayCardResponse[1]['due_date']
        elsif creditCard == 'capitalone'
            @capitalOne = BankCapitalOne.new(
                Encrypter.new.decrypt(CapitalOneUsername),
                Encrypter.new.decrypt(CapitalOneSecurity),
                displays,
                headless,
                displayProgress
            )
            @capitalOneResponse = @capitalOne.getBalances(false)
            @outstanding_balance = @capitalOneResponse[1]['balance']
            @minimum_payment = @capitalOneResponse[1]['minimum_payment']
            @due_date = @capitalOneResponse[1]['due_date']
        elsif creditCard == 'lloyds'
            @lloyds = BankLloyds.new(
                Encrypter.new.decrypt(LloydsUsername),
                Encrypter.new.decrypt(LloydsPassword),
                Encrypter.new.decrypt(LloydsSecurity),
                displays,
                headless,
                displayProgress
            )
            @lloydsResponse = @lloyds.getBalances(false)
            @outstanding_balance = @lloydsResponse[1]['cc_balance']
            @minimum_payment = @lloydsResponse[1]['cc_minimum_payment']
            @due_date = @lloydsResponse[1]['cc_due_date']
        end

        self.displayOutstandingBalance

        # Get Bank Account(s)
        bankAccounts.each do |bankAccount|
            payment_account = {}
            if bankAccount == 'lloyds'
                if !defined? @lloyds
                    @lloyds = BankLloyds.new(
                        Encrypter.new.decrypt(LloydsUsername),
                        Encrypter.new.decrypt(LloydsPassword),
                        Encrypter.new.decrypt(LloydsSecurity),
                        displays,
                        headless,
                        displayProgress
                    )
                    @lloydsResponse = @lloyds.getBalances(false)
                end
                payment_account['account_id'] = 'lloyds'
                payment_account['account_name'] = 'Lloyds Current Account'
                payment_account['balance'] = @lloydsResponse[1]['account_1_balance']
                payment_account['available'] = @lloydsResponse[1]['account_1_available']
            elsif bankAccount == 'halifax'
                @halifax = BankHalifax.new(
                    Encrypter.new.decrypt(HalifaxUsername),
                    Encrypter.new.decrypt(HalifaxPassword),
                    Encrypter.new.decrypt(HalifaxSecurity),
                    displays,
                    headless,
                    displayProgress
                )
                @halifax = @halifax.getBalances(false)
                payment_account['account_id'] = 'halifax'
                payment_account['account_name'] = 'Halifax Reward Account'
                payment_account['balance'] = @halifax[1]['account_2_balance']
                payment_account['available'] = @halifax[1]['account_2_available']
            elsif bankAccount == 'natwest'
                @natwest = BankNatWest.new(
                    Encrypter.new.decrypt(NatWestUsername),
                    Encrypter.new.decrypt(NatWestSecurityTop),
                    Encrypter.new.decrypt(NatWestSecurityBottom),
                    displays,
                    headless,
                    displayProgress
                )
                @natwest = @natwest.getBalances(false)
                payment_account['account_id'] = 'natwest'
                payment_account['account_name'] = 'NatWest Advantage Gold'
                payment_account['balance'] = @natwest[1]['advantage_gold']
                payment_account['available'] = @natwest[1]['advantage_gold']
            end
            puts "\n"
            @payment_accounts.push(payment_account)
        end

        self.displayPaymentAccountBalances
        self.getUserInput

        if creditCard == 'barclaycard'
            puts "\n"
            @barclayCard.payBarclayCard(@chosenAmount, @chosenAccount, @barclayCardResponse[0])
            puts "\n"
        elsif creditCard == 'capitalone'
            puts "\n"
            @capitalOne.payCapitalOne(@chosenAmount, @chosenAccount, @capitalOneResponse[0])
            puts "\n"
        elsif creditCard == 'lloyds'
            puts "\n"
            @lloyds.payLloyds(@chosenAmount, @chosenAccount, @lloydsResponse[0])
            puts "\n"
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

        if @minimum_payment > 0
            puts "Minimum Payment            : \x1B[31m#{toCurrency(@minimum_payment).to_s.rjust(11)}\x1B[0m"
        else
            puts "Minimum Payment            : #{toCurrency(@minimum_payment).to_s.rjust(11)}"
        end
        puts "Due Date                   : \x1B[0m#{@due_date.strftime('%d-%m-%y').to_s.rjust(11)} \x1B[90m[in #{diffBetweenDatesInDays(@due_date.strftime('%y-%m-%d'))} days]\x1B[0m"
        puts "\n"
    end

    # Display the balances of the accounts I can make payment with
    def displayPaymentAccountBalances
        count = 0
        @payment_accounts.each do |payment_account|
            count = count + 1
            @payment_map[count] = {}
            @payment_map[count]['account_id'] = payment_account['account_id']
            @payment_map[count]['account_name'] = payment_account['account_name']
            if payment_account['balance'] > 0
                puts "#{count}) #{payment_account['account_name'].ljust(24)}: \x1B[32m#{toCurrency(payment_account['balance']).to_s.rjust(11)} \x1B[90m(#{toCurrency(payment_account['available'])} Available)\x1B[0m"
            else
                puts "#{count}) #{payment_account['account_name'].ljust(24)}: \x1B[31m#{toCurrency(payment_account['balance']).to_s.rjust(11)} \x1B[90m(#{toCurrency(payment_account['available'])} Available)\x1B[0m"
            end
        end
        puts "\n"
    end

    # Get the inputs from the user for how much to pay, where to pay it from, etc.
    def getUserInput
        until inArray(getKeysInHash(@payment_map), @chosenAccount)
            STDOUT.flush
            print "\x1B[90mWhat account would you like to make the payment from? [ie: 1]\x1B[0m => "
            if @payment_map.count == 1
                @chosenAccount = 1
                print 1
                puts
            else
                @chosenAccount = STDIN.gets.chomp
                @chosenAccount = @chosenAccount.to_i
            end
        end
        puts "\n\x1B[44m ACC \x1B[0m \x1B[33m#{@payment_map[@chosenAccount]['account_name']}\x1B[0m\n\n"
        @chosenAccount = @payment_map[@chosenAccount]['account_id']
        until @chosenAmount > 0
            STDOUT.flush
            print "\x1B[90mHow much would you like to pay? [ie: 15.00]\x1B[0m => "
            @chosenAmount = STDIN.gets.chomp
            @chosenAmount = @chosenAmount.to_f
        end
        puts "\n\x1B[44m PAY \x1B[0m \x1B[33m#{toCurrency(@chosenAmount)}\x1B[0m\n\n"
        puts "\x1B[90mYou are about to make a payment of \x1B[32m#{toCurrency(@chosenAmount)}\x1B[90m. Once started, the process cannot be aborted.\x1B[0m\n\n"
        @chosenAmount = toCurrency(@chosenAmount, '', '')
        proceed = false
        until proceed == true
            STDOUT.flush
            print "\x1B[42m Confirm \x1B[0m \x1B[32mAre you absolutely sure you want to continue? \x1B[90m[y/n]\x1B[0m => "
            userResponse = STDIN.gets.chomp
            if userResponse == 'y'
                proceed = true
            elsif userResponse == 'n'
                puts "\n\x1B[41m Abort \x1B[0m You've chosen to abort paying your credit card. Goodbye!\n\n"
                exit
            end
        end
    end

end