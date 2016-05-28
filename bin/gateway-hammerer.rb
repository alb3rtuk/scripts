# HAMMERS THE GATEWAY SERVICE WITH TONS OF FAKE EBAY PLATFORM NOTIFICATIONS.

require('rest_client')

all_files = Dir[File.expand_path('~/Repos/nimzo-ruby/assets/ebay-all/**/*.xml')]

fire_only_responses_with = [
    'GetItemTransactionsResponse'
]

fire_all = true

counter = 0

all_files.each do |filename|

    counter = counter + 1

    file = File.open(filename, 'rb')
    contents = file.read

    fire_only_responses_with.each do |regex|

        if contents =~ /#{regex}/ || fire_all

            puts filename

            begin

                result = RestClient.post 'http://localhost:6015/ebay/notification', contents

            rescue Exception => e
                puts
                puts "\x1B[38;5;196mSomething went wrong: \x1B[0m#{e}"
                puts result.inspect
                puts
            end

            if counter >= 4

                counter = 0
                sleep(1)

            end

            break
        end

    end

end

