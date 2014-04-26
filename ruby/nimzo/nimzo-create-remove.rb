require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-maker.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo-file-rewriter.rb'

class NimzoCreateRemove

    LIB = 'lib'
    CREATE = 'create'
    REMOVE = 'remove'
    SCRIPT = 'script'

    # The point of entry!
    # @param route
    # @param type
    # @param action
    def initialize(type, route, action, helper = nil)

        @type = type.downcase
        @route = route.sub(/^[\/]*/, '').sub(/(\/)+$/, '').squeeze('/')
        @action = action.downcase
        @helper = helper

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

        if @type == LIB || @type == SCRIPT
            self.createLibScript
        else
            if inArray(%w(pagehelper modalhelper overlayhelper systemhelper widgethelper), @type)
                self.createHelper
            else
                self.createRoute
            end
        end

    end

    # Validate the input parameters
    def validateParameters

        # Make sure the particular controller type is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(page pagehelper lib script modal modalhelper overlay overlayhelper system systemhelper widget widgethelper), @type)
            self.error("\x1B[33m#{@type}\x1B[0m is not a valid type. There is an error in your bash script, not your input.")
        end

        # Make sure the particular action is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray([CREATE, REMOVE], @action)
            self.error("\x1B[33m#{@action}\x1B[0m is not a valid action. There is an error in your bash script, not your input.")
        end

        if @type == LIB || @type == SCRIPT

            # Make sure the route consists of a parent directory and a classname
            unless @route.include?('/')
                self.error("You must specify a \x1B[33mfolder\x1B[0m and a \x1B[33mclassname\x1B[0m (IE: core/AjaxRequest)")
            end

            # Right now I'm only allowing the creation of scripts 1 folder deep.
            # Although the PHP supports infinite folders, I want to keep it from getting too confusing.
            #
            # If more than 1 slash is present, this cuts it down to only 1. Everything after the 2nd will be ommited.
            # Also capitalizes the 2nd part & removes file extension (if exists)
            routeSplit = @route.split('/')
            className = File.basename(routeSplit[1], File.extname(routeSplit[1]))
            className[0] = className.upcase[0..0]
            @route = "#{routeSplit[0].downcase}/#{className}"

            # Make sure folder doesn't start with following values. These will just create confusion.
            if inArray(%w(bin lib script scripts), routeSplit[0], true) &&
                self.error("Namespace/preceeding folder shouldn't be \x1B[33m#{routeSplit[0]}\x1B[0m due to possible confusion.")
            end

            # Make sure that ALL characters within the route are AlphaNumeric.
            unless isAlphaNumeric(@route.gsub('/', ''))
                self.error("\x1B[33mFolder\x1B[0m and a \x1B[33mclassname\x1B[0m must be alphanumeric and seperated by a slash ('/'). You passed: \x1B[33m#{@route}\x1B[0m")
            end

        else
            # Make sure route doesn't start with API or AJAX
            routeSplit = @route.split('/')
            if inArray(%w(api ajax script), routeSplit[0], true) &&
                self.error("Request route cannot start with \x1B[33m#{routeSplit[0]}\x1B[0m as these are parameters the system uses.")
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

            # Make sure the helper parameter is correct (if this is a 'helper' run)
            if inArray(%w(pagehelper modalhelper overlayhelper systemhelper widgethelper), @type)

                # Make sure @helper is not nil
                if @helper.nil? || @helper == ''
                    self.error('@helper variable is nil or not set.')
                end

                @helper = File.basename(@helper, File.extname(@helper))
                @helper[0] = @helper.upcase[0..0]

                # Make sure helper is alphanumeric.
                # Make sure that ALL characters within the route are AlphaNumeric.
                unless isAlphaNumeric(@helper)
                    self.error("Helper name must be alphanumeric. You passed: \x1B[33m#{@helper}\x1B[0m")
                end
            end
        end

    end

    # Creates a helper class.
    def createHelper

        case @type
            when 'pagehelper'
                @type = 'page'
            when 'modalhelper'
                @type = 'modal'
            when 'overlayhelper'
                @type = 'overlay'
            when 'systemhelper'
                @type = 'system'
            when 'widgethelper'
                @type = 'widget'
            else
                self.error('Type not supported.')
        end

        helperPath = "#{$PATH_TO_PHP}#{@type}/helpers/#{@route}/"
        helperPathTest = "#{$PATH_TO_TESTS}#{@type}/helpers/#{@route}/"
        helperFile = "#{helperPath}#{@helper}.php"
        helperFileTest = "#{helperPathTest}#{@helper}Test.php"

        if @action == CREATE

            # Check that the helper paths even exist.
            unless File.directory?(helperPath)
                self.error("The route \x1B[35m#{@route}\x1B[0m doesn't exist for content type: \x1B[44m #{@type.capitalize} \x1B[0m")
            end
            unless File.directory?(helperPathTest)
                self.error("The route \x1B[35m#{@route}\x1B[0m doesn't exist for content type: \x1B[44m #{@type.capitalize} \x1B[0m")
            end

            # Now check that the helper files DON'T exist.
            if File.file?(helperFile)
                self.error("The file \x1B[33m#{helperFile}\x1B[0m already exists.")
            end
            if File.file?(helperFileTest)
                self.error("The file \x1B[33m#{helperFileTest}\x1B[0m already exists.")
            end

            @files.push(helperFile)
            @files.push(helperFileTest)

            @output.push("\x1B[42m CREATE \x1B[0m  Determining files/directories which need to be created:\n")
            @output.push("          \x1B[33m#{helperFile.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            @output.push("          \x1B[33m#{helperFileTest.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m\n")
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[42m CREATE \x1B[0m\x1B[90m these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            puts
            NimzoFileMaker.new(@type, @paths, @files, '          ')
            puts
        elsif @action == REMOVE

            filesToDelete = Array.new

            # Check that the helper files we're trying to delete exist.
            if File.file?(helperFile)
                filesToDelete.push(helperFile)
                @output.push("          \x1B[33m#{helperFile.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            end
            if File.file?(helperFileTest)
                filesToDelete.push(helperFileTest)
                @output.push("          \x1B[33m#{helperFileTest.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            end

            # If helper files don't exist, abandon ship!
            if filesToDelete.empty?
                self.error("The helper \x1B[35m#{@helper}\x1B[0m doesn't exist for \x1B[44m #{@type.capitalize} \x1B[0m \x1B[35m#{@route}\x1B[0m")
            end

            @output.push('')
            @output.unshift("\x1B[41m REMOVE \x1B[0m  Gathering files/directories for removal:\n")
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[41m PERMANENTLY REMOVE \x1B[0m\x1B[90m all of these files. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            unless filesToDelete.empty?
                filesToDelete.each { |file|
                    @output.push("\x1B[31mRemoved:  #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    # Remove file from Git.
                    system ("git rm -f #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]} > /dev/null 2>&1")
                    FileUtils.rm_rf(file)

                    # When deleting the last file in a direcotry, Ruby for some stupid reason deletes
                    # the parent directory as well. This in turn crashed the unit tests so instead of trying to
                    # figure this out, I'm just going to check & re-create the directory if it's been wiped. Easy peasy.
                    dir = File.dirname(file)
                    unless File.directory?(dir)
                        FileUtils::mkdir_p(dir)
                    end
                }
            end
            @output.push('')
            self.flushBuffer
        end
        self.runUnitTests
    end

    # Creates a class within the /lib directory + also creates the UNIT Test boiler plate.
    def createLibScript

        routeSplit = @route.split('/')
        filename = ''
        filenameTest =''


        if @type == LIB
            filename = "#{$PATH_TO_PHP}lib/#{routeSplit[0]}/#{routeSplit[1]}.php"
            filenameTest = "#{$PATH_TO_TESTS}lib/#{routeSplit[0]}/#{routeSplit[1]}Test.php"
        elsif @type == SCRIPT
            filename = "#{$PATH_TO_PHP}script/#{routeSplit[0]}/#{routeSplit[1]}.php"
            filenameTest = "#{$PATH_TO_TESTS}script/#{routeSplit[0]}/#{routeSplit[1]}Test.php"
        else
            self.error('Type is not supported.')
        end


        if @action == CREATE

            # Make sure the files don't already exist.
            # The last thing we want to do is overwrite files.
            if File.file?(filename)
                self.error("File already exists: \x1B[33m#{filename}\x1B[0m")
                exit
            elsif File.file?(filenameTest)
                self.error("File already exists: \x1B[33m#{filenameTest}\x1B[0m")
                exit
            end

            @files.push(filename)
            @files.push(filenameTest)
            @output.push("\x1B[42m CREATE \x1B[0m  Determining files/directories which need to be created:\n")
            @output.push("          \x1B[33m#{filename.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            @output.push("          \x1B[33m#{filenameTest.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m\n")
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[42m CREATE \x1B[0m\x1B[90m these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            puts
            NimzoFileMaker.new(@type, @paths, @files, '          ')
            puts
        elsif @action == REMOVE

            filesToDelete = Array.new

            # Check that the files we're trying to delete actually exist.
            if File.file?(filename)
                filesToDelete.push(filename)
                @output.push("          \x1B[33m#{filename.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            end
            if File.file?(filenameTest)
                filesToDelete.push(filenameTest)
                @output.push("          \x1B[33m#{filenameTest.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m")
            end

            # If helper files don't exist, abandon ship!
            if filesToDelete.empty?
                self.error("The file \x1B[35m#{filename.sub("#{@pathToRepo}/", '')[0..-1]}\x1B[0m doesn't exist.")
            end

            @output.push('')
            @output.unshift("\x1B[41m REMOVE \x1B[0m  Gathering files/directories for removal:\n")
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[41m PERMANENTLY REMOVE \x1B[0m\x1B[90m all of these files. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            unless filesToDelete.empty?
                filesToDelete.each { |file|
                    @output.push("\x1B[31mRemoved:  #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    # Remove file from Git.
                    system ("git rm -f #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]} > /dev/null 2>&1")
                    FileUtils.rm_rf(file)
                }
            end
            @output.push('')
            self.flushBuffer

        end

        self.runUnitTests
    end

    # IF CREATE: Scans the route and creates all the files (that don't exist yet) along the way.
    #            Has ability to create nested paths (IE: if only '/dashboard' exists you can still create '/dashboard/messages/new').
    # IF REMOVE: Scans ONLY the last directory in the route and removes all the files recursively (if they exist).
    def createRoute

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
        filename = ''

        @route.split('/').each { |routeParameter|

            routeCount = routeCount + 1
            subDir = "#{subDir}#{routeParameter}/"

            filename = "#{filename}#{routeParameter.slice(0, 1).capitalize + routeParameter.slice(1..-1)}"

            # If this is a 'remove' run, only spring to life once we're on the last loop (if that makes sense).
            # We don't want to be deleting recursively..
            if @action == REMOVE && routeCount < @route.split('/').size
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
                            files.push("#{dir}#{@type.capitalize}_#{filename}.php")
                        when "#{@pathToPhp}views/#{subDir}"
                            files.push("#{dir}#{@type.capitalize}_#{filename}.phtml")
                        when "#{@pathToDev}#{subDir}"
                            files.push("#{dir}#{@type.capitalize}_#{filename}.less")
                            files.push("#{dir}#{@type.capitalize}_#{filename}.js")
                        when "#{@pathToMin}#{subDir}"
                            files.push("#{dir}#{@type.capitalize}_#{filename}.min.js")
                        when "#{@pathToTest}controllers/#{subDir}"
                            files.push("#{dir}#{@type.capitalize}_#{filename}Test.php")
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
                self.error("The route: \x1B[35m#{@route}\x1B[0m already exists..")
            elsif @action == REMOVE
                self.error("The route: \x1B[35m#{@route}\x1B[0m doesn't exist..")
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
        self.processRoute
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
            unless @files.empty? && @paths.empty?
                NimzoRewriter.new(@type)
            end
        elsif @action == REMOVE
            system ('clear')
            self.flushBuffer
            self.confirm("          \x1B[90mYou're about to \x1B[0m\x1B[41m PERMANENTLY REMOVE \x1B[0m\x1B[90m all of these files/directories. Continue? [y/n]\x1B[0m => ", "          \x1B[90mScript aborted.\x1B[0m")
            unless @files.empty?
                @files.each { |file|
                    @output.push("\x1B[31mRemoved:  #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    # Remove file from Git.
                    system ("git rm -f #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]} > /dev/null 2>&1")
                    FileUtils.rm_rf(file)
                    FileUtils.rm_rf(File.dirname(file))
                }
            end
            unless @paths.empty?
                @paths.each { |path|
                    @output.push("\x1B[31mRemoved:  #{path.sub("#{$PATH_TO_REPO}", '')[1..-1]}\x1B[0m")
                    FileUtils.rm_rf(path)
                }
            end
            @output.push('')
            self.flushBuffer
            unless @files.empty? && @paths.empty?
                NimzoRewriter.new(@type)
            end
        end

        self.runUnitTests
    end

    # Run (system) unit tests.
    def runUnitTests
        puts "\x1B[45m SYSTEM \x1B[0m  Initializing tests...\n\n"
        system('phpunit --bootstrap /Users/Albert/Repos/Nimzo/tests-php/bin/PHPUnit_Bootstrap.php --no-configuration --colors --group System /Users/Albert/Repos/Nimzo/tests-php')
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

NimzoCreateRemove.new(ARGV[0], ARGV[1], ARGV[2], ARGV[3])