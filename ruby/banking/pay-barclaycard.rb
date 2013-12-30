require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'

require 'time'


#barclayCard = barclayCard.getBalances(false)
#barclayCardBalances = barclayCard[1]

barclayCardBalances = {"balance" => 19.69, "available_funds" => 1585.31, "credit_limit" => 1600.0, "minimum_payment" => 5.0, "due_date" => DateTime.new(2014, 1, 7)}





exit

# STEP 1 - Display the outstanding balance & payment options.
if ARGV[0] == 'ydHyu8kdjZl12wAq=='
    puts "\n"

    #barclayCard = barclayCard.getBalances(false)
    #barclayCardBalances = barclayCard[1]

    barclayCardBalances = {"balance" => 19.69, "available_funds" => 1585.31, "credit_limit" => 1600.0, "minimum_payment" => 5.0, "due_date" => DateTime.new(2014, 1, 7)}

    # Calculates how many days left till payment is due.
    today = DateTime.now
    today = Date.parse(today.strftime('%y-%m-%d'))
    dueDate = Date.parse(barclayCardBalances['due_date'].strftime('%y-%m-%d'))
    daysLeft = dueDate.mjd - today.mjd

    puts "\n"
    if barclayCardBalances['balance'] > 0
        puts "Outstanding Balance        : \x1B[31m#{toCurrency(barclayCardBalances['balance']).to_s.rjust(11)}\x1B[0m"
    else
        puts "Outstanding Balance        : #{toCurrency(barclayCardBalances['balance']).to_s.rjust(11)}"
    end

    if barclayCardBalances['minimum_payment']
        puts "Minimum Payment            : \x1B[31m#{toCurrency(barclayCardBalances['minimum_payment']).to_s.rjust(11)}\x1B[0m"
    else
        puts "Minimum Payment            : #{toCurrency(barclayCardBalances['minimum_payment']).to_s.rjust(11)}"
    end
    puts "Due Date                   : \x1B[90m#{barclayCardBalances['due_date'].strftime('%d-%m-%y').to_s.rjust(11)} (in #{daysLeft} days)\x1B[0m"

    #puts "\n"
    #natWest = natWest.getBalances(false)
    #natWestBalances = natWest[1]
    #puts "\n"
    #halifax = halifax.getBalances(false)
    #halifaxBalances = halifax[1]
    #puts "\n"

    puts "\n"
    halifaxBalances = {}
    halifaxBalances['account_2_available'] = -4192.52
    natWestBalances = {}
    natWestBalances['advantage_gold'] = 1957.59

    if (halifaxBalances['account_2_available'] > 0)
        puts "1) NatWest Advantage Gold  : \x1B[32m#{toCurrency(natWestBalances['advantage_gold']).to_s.rjust(11)}\x1B[0m"
    else
        puts "1) NatWest Advantage Gold  : \x1B[31m#{toCurrency(natWestBalances['advantage_gold']).to_s.rjust(11)}\x1B[0m"
    end

    if (natWestBalances['advantage_gold'] >= 0)
        puts "2) Halifax Reward          : \x1B[32m#{toCurrency(halifaxBalances['account_2_available']).to_s.rjust(11)}\x1B[0m"
    else
        puts "2) Halifax Reward          : \x1B[31m#{toCurrency(halifaxBalances['account_2_available']).to_s.rjust(11)}\x1B[0m"
    end
    puts "\n"



end
