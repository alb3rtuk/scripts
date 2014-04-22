require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

class NimzoCreateDelete

    # The point of entry!
    # @param route
    # @param type
    # @param action
    def initialize(route, type, action)
        @route = route
        @type = type
        @action = action

        @errors = false
        @output = Array.new

        @filenameUpperCase = ''
        @filenameLowerCase = ''
        @pathToRepo = '/Users/Albert/Repos/Nimzo/httpdocs'
        @pathToRepoSlash = '/Users/Albert/Repos/Nimzo/httpdocs/'
        @pathToTests = '/Users/Albert/Repos/Nimzo/tests-php'


        self.validateParameters
        self.run
    end


    # Validate the input parameters
    def validateParameters

        # Make sure the particular controller type is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(app modal overlay system widget), @type)
            @errors = true
            self.error("\x1B[33m#{@type}\x1B[0m is not a valid controller type. There is an error in your bash script, not your input.")
        end

        # Make sure the particular action is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(create delete), @action)
            @errors = true
            self.error("\x1B[33m#{@action}\x1B[0m is not a valid action. There is an error in your bash script, not your input.")
        end

        # Make sure route doesn't start with API or AJAX.
        routeSplit = @route.split('/')
        routeSplit = routeSplit[0]
        if inArray(%w(api ajax), routeSplit, true)
            self.error("Request route cannot start with: \x1B[33m#{routeSplit}\x1B[0m")
        end

        # Make sure that ALL characters within the route are AlphaNumeric.
        unless isAlphaNumeric(@route.gsub('/', ''))
            @errors = true
            self.error("Route parameters must be alphanumeric and seperated by slashes ('/'). You passed: \x1B[33m#{@route}\x1B[0m")
        end

        # Make sure that the FIRST character of ANY route parameter is a letter, not a number.
        routeSplit = @route.split('/')
        routeSplit.each { |routeParameter|
            if (routeParameter[0, 1] =~ /[A-Za-z]/) != 0
                self.error("Route parameters cannot start with a digit (IE: 0-9). You passed: \x1B[33m#{@route}\x1B[0m")
            end
        }

    end

    # If an error occurs, it's added to the @OUTPUT array and if 'exit' flag set to TRUE,
    # the script goes straight to run & subsequently displays output & dies.
    # @param text
    # @param exit
    def error(text = '', exit = true)
        @errors = true
        @output.push("\x1B[41m ERROR \x1B[0m #{text}")
        if exit
            self.run
        end
    end

    # The final function which doesn all the processing. If errors are present, no processing will be done.
    def run
        unless @errors

            puts 'No errors!'

        end
        self.displayOutput
    end

    # No matter what, at the end of EVERY script run, whatever's in the @OUTPUT buffer will
    # get echoed to Terminal.
    def displayOutput
        unless @output.empty?
            puts
            @output.each { |message| puts "#{message}\x1B[0m" }
            if @errors
                puts "        \x1B[90mScript aborted.\x1B[0m"
            end
            puts
        end
        exit
    end

end

NimzoCreateDelete.new(ARGV[0].sub(/^[\/]*/, '').sub(/(\/)+$/, ''), ARGV[1], ARGV[2])