require '/Users/Natalee/Repos/Scripts/ruby/lib/utilities.rb'

class LottoPredicter

    ROUTE_GET = 'get'
    ROUTE_PREDICT = 'predict'
    ROUTE_CRON = 'cron'
    ROUTE_CRON_MANUAL = 'cron-manual'

    # Initialize the class.
    # @return void
    def initialize(route)
        @route = route.nil? ? ROUTE_PREDICT : route
        error("Route: #{@route} is not recognized.") if !inArray(Array['', ROUTE_GET, ROUTE_PREDICT, ROUTE_CRON, ROUTE_CRON_MANUAL], @route)






        run
    end

    # Main run function.
    # @return void
    def run
        case @route
            when ROUTE_GET
                runGetLottoData
            when ROUTE_PREDICT
                runPrediction
            when ROUTE_CRON
                runCron
            when ROUTE_CRON_MANUAL
                runCron(true)
            else
                error("Route: #{@route} is not recognized.")
        end
    end

    # Gets the last 180 days worth of Data and inserts it into MySQL
    # @return void
    def runGetLottoData

        # http://apidock.com/ruby/CSV

        # lottoData = Net::HTTP.get(URI.parse('https://www.national-lottery.co.uk/player/lotto/results/downloadResultsCSV.ftl'))
        # writeDataToFile(lottoData, 'tmp/lottoData.csv')

        CSV.foreach('/Users/Natalee/Downloads/us-500.csv') do |row|
            puts row.inspect
        end

    end

    # Command line utility Point of Entry
    # @return void
    def runPrediction

    end

    # Cron Point of Entry
    # @return void
    def runCron(displayProgress = false)
        displayProgress

    end

    # Displays error and exits script
    # @return void
    def error(text = '')
        puts "\x1B[41m ERROR \x1B[0m #{text}\n\n"
        exit
    end

end