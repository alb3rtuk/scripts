require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-maker.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-rewriter.rb'

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
        @pathToPhp = "#{@pathToRepo}/httpdocs/private/#{@type}/"
        @pathToDev = "#{@pathToRepo}/httpdocs/public/dev/#{@type}/"
        @pathToMin = "#{@pathToRepo}/httpdocs/public/min/#{@type}/"
        @pathToTest = "#{@pathToRepo}/tests-php/private/#{@type}/"

        @paths = Array.new
        @files = Array.new

        self.validateParameters
        self.scanRoute
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

    # Scans the route to the controller and creates all the files (that don't exist yet) along the way.
    # Has ability to create nested paths (IE: if only '/dashboard' exists you can still create '/dashboard/messages/new').
    def scanRoute

        baseDirs = Array[
            "#{@pathToPhp}helpers/",
            "#{@pathToPhp}controllers/",
            "#{@pathToPhp}views/",
            "#{@pathToDev}",
            "#{@pathToTest}controllers/"
        ]

        # If we're creating stuff..
        if @action == 'create'
            subDir = ''
            filenameUpperCase = ''
            @route.split('/').each { |routeParameter|

                subDir = "#{subDir}#{routeParameter}/"

                pseudoOutput = Array.new
                pseudoPaths = Array.new
                pseudoFiles = Array.new

                filenameUpperCase = "#{filenameUpperCase}#{routeParameter.slice(0, 1).capitalize + routeParameter.slice(1..-1)}"
                filenameLowerCase = filenameUpperCase[0, 1].downcase + filenameUpperCase[1..-1]

                baseDirs.each { |dir|
                    dir = "#{dir}#{subDir}"
                    if dir == "#{@pathToPhp}helpers/#{subDir}"
                        unless File.directory?(dir)
                            pseudoOutput.push("           \x1B[32m#{dir.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
                            pseudoPaths.push(dir)
                        end
                    else
                        files = Array.new
                        case dir
                            when "#{@pathToPhp}controllers/#{subDir}"
                                files.push("#{dir}#{filenameUpperCase}.php")
                            when "#{@pathToPhp}views/#{subDir}"
                                files.push("#{dir}#{filenameUpperCase}.phtml")
                            when "#{@pathToDev}#{subDir}"
                                files.push("#{dir}#{filenameLowerCase}.js")
                                files.push("#{dir}#{filenameLowerCase}.less")
                            when "#{@pathToTest}controllers/#{subDir}"
                                files.push("#{dir}#{filenameUpperCase}Test.php")
                            else
                                @errors = true
                                self.error('Path not found.')
                        end
                        files.each { |file|
                            unless File.file?(file)
                                pseudoFiles.push(file)
                                count = 0
                                fileDisplay = ''
                                file.split('/').each { | filePart |
                                    count = count + 1
                                    if count < file.split('/').length
                                        fileDisplay = "#{fileDisplay}/#{filePart}"
                                    else
                                        fileDisplay = "#{fileDisplay}/\x1B[36m#{filePart}\x1B[0m"
                                    end
                                }
                                # Remove preceeding slash (/) as a result of above loop..
                                fileDisplay[0] = ''
                                pseudoOutput.push("           \x1B[33m#{fileDisplay.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
                            end
                        }
                    end
                }
                unless pseudoPaths.empty?
                    @paths.concat(pseudoPaths)
                end
                unless pseudoFiles.empty?
                    @files.concat(pseudoFiles)
                end
                unless pseudoPaths.empty? && pseudoFiles.empty?
                    pseudoOutput.unshift("           \x1B[35m#{subDir[0..-2]}\x1B[0m")
                    pseudoOutput.push('')
                    @output.concat(pseudoOutput)
                end
            }
            if @paths.empty? && @files.empty?

                self.error('This route already exists..')

            else
                @output.unshift("\x1B[42m CONFIRM \x1B[0m  For this route, the following file(s)/directori(es) will need to be created:\n")
            end
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

#            @output.unshift("\x1B[42m CONFIRM \x1B[0m  Would you like to create the following file(s)/diretori(es):\n")

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