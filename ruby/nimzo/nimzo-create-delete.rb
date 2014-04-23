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
            "#{@pathToTest}helpers/",
            "#{@pathToTest}controllers/",
            "#{@pathToPhp}controllers/",
            "#{@pathToPhp}views/",
            "#{@pathToDev}"
        ]

        routeCount = 0
        subDir = ''
        filenameUpperCase = ''

        @route.split('/').each { |routeParameter|

            routeCount = routeCount + 1
            subDir = "#{subDir}#{routeParameter}/"

            filenameUpperCase = "#{filenameUpperCase}#{routeParameter.slice(0, 1).capitalize + routeParameter.slice(1..-1)}"
            filenameLowerCase = filenameUpperCase[0, 1].downcase + filenameUpperCase[1..-1]

            # If this is a 'delete' run, only spring to life once we're on the last loop (if that makes sense).
            # We don't want to be deleting recursively..
            if @action == 'delete' && routeCount < @route.split('/').size
                next
            end

            pseudoOutput = Array.new
            pseudoPaths = Array.new
            pseudoFiles = Array.new

            baseDirs.each { |dir|
                dir = "#{dir}#{subDir}"
                if dir == "#{@pathToPhp}helpers/#{subDir}" || dir == "#{@pathToTest}helpers/#{subDir}"
                    if (@action == 'create' && !File.directory?(dir)) || (@action == 'delete' && File.directory?(dir))
                        pseudoOutput.push("          \x1B[32m#{dir.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
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
                            files.push("#{dir}#{filenameLowerCase}.less")
                            files.push("#{dir}#{filenameLowerCase}.js")
                        when "#{@pathToTest}controllers/#{subDir}"
                            files.push("#{dir}#{filenameUpperCase}Test.php")
                        else
                            @errors = true
                            self.error('Path not found.')
                    end
                    files.each { |file|
                        if (@action == 'create' && !File.file?(file)) || (@action == 'delete' && File.file?(file))
                            pseudoFiles.push(file)
                            fileCount = 0
                            fileDisplay = ''
                            file.split('/').each { |filePart|
                                fileCount = fileCount + 1
                                if fileCount < file.split('/').length
                                    fileDisplay = "#{fileDisplay}/#{filePart}"
                                else
                                    fileDisplay = "#{fileDisplay}/\x1B[36m#{filePart}\x1B[0m"
                                end
                            }
                            # Remove preceeding slash (/) as a result of above loop..
                            fileDisplay[0] = ''
                            pseudoOutput.push("          \x1B[33m#{fileDisplay.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
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
                pseudoOutput.unshift("          \x1B[90m#{@type.upcase}\x1B[0m => \x1B[35m#{subDir[0..-2]}\x1B[0m")
                pseudoOutput.push('')
                @output.concat(pseudoOutput)
            end
        }
        if @paths.empty? && @files.empty?
            if @action == 'create'
                self.error("The route: \x1B[35m#{@route}\x1B[0m already exists..")
            elsif @action == 'delete'
                self.error("The route: \x1B[35m#{@route}\x1B[0m doesn't exist..")
            end
        else
            if @action == 'create'
                @output.unshift("\x1B[42m CREATE \x1B[0m  Determining files/directories which need to be created:\n")
            elsif @action == 'delete'
                @output.unshift("\x1B[41m DELETE \x1B[0m  Gathering files/directories for removal:\n")
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
            @errors = true
            self.flushBuffer
        end
    end

    # The final function which does all the processing. If errors are present, no processing will be done.
    def run
        unless @errors
            if @action == 'create'
                system ('clear')
                self.flushBuffer
                self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[42m CREATE \x1B[0m\x1B[90m these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
                puts
                NimzoFileMaker.new(@paths, @files, '          ')
                puts
            elsif @action == 'delete'
                system ('clear')
                self.flushBuffer
                self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[41m PERMANENTLY DELETE \x1B[0m\x1B[90m these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")

            end

        end
    end

    # Confirmation message. Returns and continues script on 'y' or 'Y'.. exits on anythng else.
    def confirm(confirmTxt = "\x1B[90mContinue? [y/n]\x1B[0m => ?", abortTxt = nil)
        STDOUT.flush
        print confirmTxt
        continue = STDIN.gets.chomp
        if continue != 'y' && continue != 'Y'
            self.abandonShip(abortTxt)
        end
    end

    # Flushes the output buffer.
    def flushBuffer
        unless @output.empty?
            puts
            @output.each { |message| puts "#{message}\x1B[0m" }
            if @errors
                self.abandonShip
            else
                @output = Array.new
            end
        end
    end

    # Aborts the script.
    def abandonShip(abortTxt = "        \x1B[90mScript aborted.\x1B[0m")
        unless abortTxt.nil?
            puts abortTxt
        end
        puts
        exit
    end

end

NimzoCreateDelete.new(ARGV[0], ARGV[1], ARGV[2])