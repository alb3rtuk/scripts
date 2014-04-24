require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-maker.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-rewriter.rb'

class NimzoCreateRemove

    CREATE = 'create'
    REMOVE = 'remove'

    # The point of entry!
    # @param route
    # @param type
    # @param action
    def initialize(type, route, action)

        @type = type.downcase
        @route = route.sub(/^[\/]*/, '').sub(/(\/)+$/, '').squeeze('/')
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

        if @type == 'lib'
            puts @route
            exit
        else
            self.determineRoute
            self.processRoute
        end

    end

    # Validate the input parameters
    def validateParameters

        # Make sure the particular controller type is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(app lib modal overlay system widget), @type)
            self.error("\x1B[33m#{@type}\x1B[0m is not a valid type. There is an error in your bash script, not your input.")
        end

        # Make sure the particular action is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray([CREATE, REMOVE], @action)
            self.error("\x1B[33m#{@action}\x1B[0m is not a valid action. There is an error in your bash script, not your input.")
        end

        if @type == 'lib'
            # Make sure the route consists of a parent directory and a classname
            unless @route.include?('/')
                self.error("You must specify a \x1B[33mfolder\x1B[0m and a \x1B[33mclassname\x1B[0m (IE: core/AjaxRequest)")
            end

            # If more than 1 slash is present, this cuts it down to only 1. Everything after the 2nd will be ommited.
            # Also capitalizes the 2nd part & removes file extension (if exists)
            routeSplit = @route.split('/')
            className = File.basename(routeSplit[1], File.extname(routeSplit[1]))
            className[0] = className.upcase[0..0]
            @route = "#{routeSplit[0].downcase}/#{className}"

        else
            # Make sure route doesn't start with API or AJAX
            routeSplit = @route.split('/')
            if inArray(%w(api ajax), routeSplit[0], true) &&
                self.error("Request route cannot start with: \x1B[33m#{routeSplit[0]}\x1B[0m")
            end

            # Make sure that ALL characters within the route are AlphaNumeric.
            unless isAlphaNumeric(@route.gsub('/', ''))
                self.error("Route parameters must be alphanumeric and seperated by slashes ('/'). You passed: \x1B[33m#{@route}\x1B[0m")
            end

            # Make sure that the FIRST character of ANY route parameter is a letter, not a number.
            @route.split('/').each { |routeParameter|
                if (routeParameter[0, 1] =~ /[A-Za-z]/) != 0
                    self.error("Route parameters cannot start with a digit (IE: 0-9). You passed: \x1B[33m#{@route}\x1B[0m")
                end
            }
        end

    end

    # IF CREATE: Scans the route and creates all the files (that don't exist yet) along the way.
    #            Has ability to create nested paths (IE: if only '/dashboard' exists you can still create '/dashboard/messages/new').
    # IF REMOVE: Scans ONLY the last directory in the route and removes all the files recursively (if they exist).
    # @param route

    def determineRoute(route = @route)

        baseDirs = Array[
            "#{@pathToPhp}helpers/",
            "#{@pathToTest}helpers/",
            "#{@pathToTest}controllers/",
            "#{@pathToPhp}controllers/",
            "#{@pathToPhp}views/",
            "#{@pathToDev}",
            "#{@pathToMin}"
        ]

        routeCount = 0
        subDir = ''
        subDirs = Array.new
        filenameUpperCase = ''

        route.split('/').each { |routeParameter|

            routeCount = routeCount + 1
            subDir = "#{subDir}#{routeParameter}/"

            filenameUpperCase = "#{filenameUpperCase}#{routeParameter.slice(0, 1).capitalize + routeParameter.slice(1..-1)}"
            filenameLowerCase = filenameUpperCase.downcase[0, 1] + filenameUpperCase[1..-1]

            # If this is a 'remove' run, only spring to life once we're on the last loop (if that makes sense).
            # We don't want to be deleting recursively..
            if @action == REMOVE && routeCount < route.split('/').size
                next
            end

            pseudoOutput = Array.new
            pseudoPaths = Array.new
            pseudoFiles = Array.new

            baseDirs.each { |dir|

                dir = "#{dir}#{subDir}"

                # If deleting, this checks if there are any FURTHER files/directories deeper in the 'route'.
                # If so, adds them to an Array for later checking.
                if @action == REMOVE
                    subFilesFound = Dir.glob("#{dir}**/*")
                    unless subFilesFound.empty?
                        subDirs.concat(subFilesFound)
                    end
                end

                if dir == "#{@pathToPhp}helpers/#{subDir}" || dir == "#{@pathToTest}helpers/#{subDir}"
                    if (@action == CREATE && !File.directory?(dir)) || (@action == REMOVE && File.directory?(dir))
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
                        when "#{@pathToMin}#{subDir}"
                            files.push("#{dir}#{filenameLowerCase}.min.js")
                        when "#{@pathToTest}controllers/#{subDir}"
                            files.push("#{dir}#{filenameUpperCase}Test.php")
                        else
                            self.error('Path not found.')
                    end
                    files.each { |file|
                        if (@action == CREATE && !File.file?(file)) || ((@action == REMOVE && File.file?(file)) || (@action == REMOVE && File.directory?(File.dirname(file))))

                            pseudoFiles.push(file)
                            pseudoPaths.push(File.dirname(file))

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

            pseudoPaths.uniq
            pseudoFiles.uniq

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
            if @action == CREATE
                self.error("The route: \x1B[35m#{route}\x1B[0m already exists..")
            elsif @action == REMOVE
                self.error("The route: \x1B[35m#{route}\x1B[0m doesn't exist..")
            end
        else
            if @action == CREATE
                @output.unshift("\x1B[42m CREATE \x1B[0m  Determining files/directories which need to be created:\n")
            elsif @action == REMOVE
                @output.unshift("\x1B[41m REMOVE \x1B[0m  Gathering files/directories for removal:\n")
            end
        end

        # If we're deleting stuff, check if there are subPaths (past the point we're deleting from).
        if @action == REMOVE && !subDirs.empty?

            subFiles = Array.new
            subPaths = Array.new
            pseudoOutput = Array.new

            subDirs.each { |subFile|
                if File.directory?(subFile)
                    unless inArray(@paths, subFile)
                        subPaths.push(subFile)
                    end
                elsif File.file?(subFile)
                    unless inArray(@files, subFile)
                        subFiles.push(subFile)
                    end
                end
            }

            unless subPaths.empty? && subFiles.empty?
                subPaths.each { |path| pseudoOutput.push("          \x1B[90m#{path.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m") }
                subFiles.each { |file| pseudoOutput.push("          \x1B[0m#{file.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m") }
                @paths.concat(subPaths)
                @files.concat(subFiles)
                @output.push("\x1B[41m NOTICE \x1B[0m\x1B[90m  The following files/directories will also be removed:\n")
                @output.concat(pseudoOutput)
                @output.push('')
            end
        end
    end

    # The final function which does all the processing. If errors are present, no processing will be done.
    def processRoute
        if @action == CREATE
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[42m CREATE \x1B[0m\x1B[90m these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            puts
            NimzoFileMaker.new(@type, @paths, @files, '          ')
            puts
        elsif @action == REMOVE
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[41m PERMANENTLY REMOVE \x1B[0m\x1B[90m all of these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            unless @files.empty?
                @files.each { |file|
                    @output.push("\x1B[31m Removed: #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    # Remove file from Git.
                    system ("git rm -f #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]} > /dev/null 2>&1")
                    FileUtils.rm_rf(file)
                    FileUtils.rm_rf(File.dirname(file))
                }
            end
            unless @paths.empty?
                @paths.each { |path|
                    @output.push("\x1B[31m Removed: #{path.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    FileUtils.rm_rf(path)
                }
            end
            @output.push('')
            self.flushBuffer
        end
        unless @files.empty? && @paths.empty?
            NimzoRewriter.new(@type)
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

    # Confirmation message. Returns and continues script on 'y' or 'Y'.. exits on anythng else.
    def confirm(confirmTxt = "\x1B[90mContinue? [y/n]\x1B[0m => ?", abortTxt = nil)
        STDOUT.flush
        print confirmTxt
        continue = STDIN.gets.chomp
        if continue != 'y' && continue != 'Y'
            self.abandonShip(abortTxt)
        end
    end

    # If an error occurs, it's added to the @OUTPUT array and if 'exit' flag set to TRUE,
    # the script goes straight to run & subsequently displays output & dies.
    # @param text
    def error(text = '')
        @output.push("\x1B[41m ERROR \x1B[0m #{text}")
        self.flushBuffer(true)
    end


    # Flushes the output buffer.
    def flushBuffer(exit = false)
        unless @output.empty?
            puts
            @output.each { |message| puts "#{message}\x1B[0m" }
            if exit
                self.abandonShip
            end
            @output = Array.new
        end
    end

    # Log something to the output buffer.
    def output(text = '')
        @output.push(text)
    end

end

NimzoCreateRemove.new(ARGV[0], ARGV[1], ARGV[2])