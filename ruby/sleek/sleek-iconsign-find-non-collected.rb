require File.expand_path('~/Repos/scripts/ruby/lib/utilities.rb')

currentConsignment = 40795470000771
endConsignment = 40795470001145

sentConsignments = Array.new
output = ''

consignments = File.open('/tmp/iconsign-sent-consignments.txt')
consignments.each_line { |line| sentConsignments << line.gsub("\n", '').to_i }

browser = getBrowser(ARGV[0], false)
browser.goto('https://www.ukmail.com/manage-my-delivery/manage-my-delivery')
browser.text_field(:id => 'Content_C001_LO_01_txtConsignmentNo').set "#{currentConsignment}"
browser.button(:id => 'Content_C001_LO_01_btnSearch').click

until currentConsignment > endConsignment
    #if sentConsignments.include?(currentConsignment)
    #else
    browser.text_field(:id => 'Content_C001_LO_02_txtConsignmentNo').set "#{currentConsignment}"
    browser.button(:id => 'Content_C001_LO_02_btnSearch').click
    if browser.h2.exists?
        status = browser.h2.text
        puts "#{currentConsignment} - #{status}"
        if status.downcase == 'awaiting collection'
            output << "#{currentConsignment} - Awaiting Collection.\n"
        elsif status.downcase == 'delayed'
            output << "#{currentConsignment} - Delayed.\n"
        elsif status.downcase == 'part delivered'
            output << "#{currentConsignment} - Part Delivered.\n"
        end
    end
    #end
    currentConsignment = currentConsignment + 1
end

File.open('/tmp/iconsign-never-collected-consignments.txt', 'w') { |file| file.write(output) }