require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

class NimzoCreateDelete

    # The point of entry!
    # @param route
    # @param type
    # @param action
    def initialize(route, type, action)

        @route = route.downcase.sub(/^[\/]*/, '').sub(/(\/)+$/, '').squeeze('/')
        @type = type.downcase
        @action = action.downcase

        @errors = false
        @output = Array.new

        @pathToRepo = $PATH_TO_REPO
        @pathToPhp = "#{$PATH_TO_PHP}/httpdocs/private/#{@type}/"
        @pathToDev = "#{$PATH_TO_DEV}/httpdocs/public/dev/#{@type}/"
        @pathToMin = "#{$PATH_TO_MIN}/httpdocs/public/min/#{@type}/"
        @pathToTest = "#{$PATH_TO_TESTS}/tests-php/private/#{@type}/"

        @route.split('/').each { |routeParameter|
            @filenameUpperCase = "#{@filenameUpperCase}#{routeParameter.slice(0, 1).capitalize + routeParameter.slice(1..-1)}"
        }
        @filenameLowerCase = @filenameUpperCase[0, 1].downcase + @filenameUpperCase[1..-1]

        @files = Array.new
        @paths = Array.new

        self.validateParameters
        self.validateRoute
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
        if inArray(%w(api ajax), routeSplit[0], true)
            self.error("Request route cannot start with: \x1B[33m#{routeSplit[0]}\x1B[0m")
        end

        # Make sure that ALL characters within the route are AlphaNumeric.
        unless isAlphaNumeric(@route.gsub('/', ''))
            @errors = true
            self.error("Route parameters must be alphanumeric and seperated by slashes ('/'). You passed: \x1B[33m#{@route}\x1B[0m")
        end

        # Make sure that the FIRST character of ANY route parameter is a letter, not a number.
        @route.split('/').each { |routeParameter|
            if (routeParameter[0, 1] =~ /[A-Za-z]/) != 0
                self.error("Route parameters cannot start with a digit (IE: 0-9). You passed: \x1B[33m#{@route}\x1B[0m")
            end
        }

    end

    # Makes sure that the route to the controller doesn't have blank (nested) paths on the way. This is a no no!
    # If only SOME paths are blank, the script will assume that these were deleted by mistake, and ask to re-create them.
    def validateRoute
        pseudoOutput = Array.new
        baseDirs = Array[
            "#{@pathToPhp}helpers/",
            "#{@pathToPhp}controllers/",
            "#{@pathToPhp}views/",
            "#{@pathToDev}",
            "#{@pathToTest}controllers/"
        ]
        count = 0
        subDir = ''
        @route.split('/').each { |routeParameter|
            count = count + 1
            # Makes sure not to include the final parameter (as this will obviously be empty)
            if count < @route.split('/').size
                subDir = "#{subDir}#{routeParameter}/"
                baseDirs.each { |dir|
                    dir = "#{dir}#{subDir}"

                    if dir == "#{@pathToPhp}helpers/#{subDir}"
                        unless File.directory?("#{dir}")
                            @errors = true
                            pseudoOutput.push("        \x1B[32m#{dir.gsub("#{@pathToRepo}/", '')[0..-2]}\x1B[0m")
                        end
                    else
                        if Dir["#{dir}*"].size <= 0
                            @errors = true
                            pseudoOutput.push("        \x1B[33m#{dir.gsub("#{@pathToRepo}/", '')[0..-2]}\x1B[0m")
                        end
                    end

                }
            end
            # If blank path(s) were found, exit on first occurence.
            if @errors
                break
            end
        }

        if @errors
            pseudoOutput.unshift("\x1B[41m ERROR \x1B[0m Blank \x1B[33mRouting Paths\x1B[0m not allowed! The following directori(es) had no file(s):\n")
            pseudoOutput.push('')
            pseudoOutput.push("        You need to create \x1B[35m#{subDir[0..-2]}\x1B[0m first.\x1B[0m")
            @output.concat(pseudoOutput)
            self.die
        end

    end

    # Log something to the output buffer.
    def output(text = '')
        @output.push(text)
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
        self.die
    end

    # No matter what, at the end of EVERY script run, whatever's in the @OUTPUT buffer will
    # get echoed to Terminal.
    def die
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

NimzoCreateDelete.new(ARGV[0], ARGV[1], ARGV[2])