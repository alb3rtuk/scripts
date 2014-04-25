require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

# Accepts arrays of paths/files, determines what content they require and then creates those files.
class NimzoFileMaker

    TYPE_CONTROLLER = 'controller'
    TYPE_JS = 'js'
    TYPE_JS_MIN = 'js-min'
    TYPE_LESS = 'less'
    TYPE_TEST = 'test'
    TYPE_VIEW = 'view'

    LIB = 'lib'
    SCRIPT = 'script'

    # @param type
    # @param paths
    # @param files
    # @param space

    def initialize(type = '', paths = Array.new, files = Array.new, space = '')

        @type = type.downcase
        @paths = paths
        @files = files
        @space = space
        @namespace = ''

        if @type != LIB && @type != SCRIPT
            @namespace = @type.capitalize
        end

        # Make sure the particular controller type is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(app lib modal overlay script system widget), @type)
            puts("\x1B[33m#{@type}\x1B[0m is not a valid type. There is an error in your bash script, not your input.")
            exit
        end

        self.createPaths
        self.createFiles

    end

    # @param paths
    def createPaths(paths = @paths)
        unless paths.kind_of?(Array)
            exitScript("Expected Array, you passed (#{paths.class})")
        end
        unless paths.empty?
            paths.each { |path| self.createPath(path) }
        end
    end

    # @param path
    def createPath(path)
        unless path.kind_of?(String)
            exitScript("Expected String, you passed (#{path.class})")
        end
        unless File.directory?(path)
            FileUtils::mkdir_p(path)
            puts "\x1B[32mCreated:\x1B[0m  \x1B[90m#{path.sub("#{$PATH_TO_PHP}/", '')[0..-1]}\x1B[0m"
        end
    end

    # @param files
    def createFiles(files = @files)
        unless files.kind_of?(Array)
            exitScript("Expected Array, you passed (#{files.class})")
        end
        unless files.empty?
            files.each { |file| self.createFile(file) }
        end
    end

    # @param file
    def createFile(file)
        unless file.kind_of?(String)
            exitScript("Expected String, you passed (#{file.class})")
        end
        if File.file?(file)
            exitScript("File already exists: #{file}")
        else
            self.createPath(File.dirname(file))
            File::new(file, 'w')
            # Add file to Git.
            system ("cd #{$PATH_TO_REPO}")
            system ("git add #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}")
            populateFile(file)
            puts "\x1B[32mCreated:\x1B[0m  \x1B[0m#{file.sub("#{$PATH_TO_REPO}/", '')[0..-1]}\x1B[0m"
        end
    end

    # Figures out what kind of file this is (controller, .js, test, etc) and then goes to create it.
    def populateFile(file)
        if file.include? "#{$PATH_TO_PHP}#{@type}/controllers/"
            # Controller
            self.createFileController(file, File.dirname(file).sub("#{$PATH_TO_PHP}#{@type}/controllers/", ''))
            return
        elsif file.include? "#{$PATH_TO_TESTS}#{@type}/controllers/"
            # Controller (Test)
            self.createFileTest(file, File.dirname(file).sub("#{$PATH_TO_TESTS}#{@type}/controllers/", ''))
            return
        elsif file.include? "#{$PATH_TO_PHP}#{@type}/views/"
            # View
            self.createFileView(file, File.dirname(file).sub("#{$PATH_TO_PHP}#{@type}/views/", ''))
            return
        elsif file.include? "#{$PATH_TO_MIN}#{@type}"
            # Min .JS
            self.createFileJsMin(file, File.dirname(file).sub("#{$PATH_TO_MIN}#{@type}", ''))
            return
        elsif file.include? "#{$PATH_TO_DEV}#{@type}"
            # Dev .JS / .Less
            if file.reverse[0..2].reverse == '.js'
                self.createFileJs(file, File.dirname(file).sub("#{$PATH_TO_DEV}#{@type}", ''))
                return
            else
                self.createFileLess(file, File.dirname(file).sub("#{$PATH_TO_DEV}#{@type}", ''))
                return
            end
        elsif (file.include? "#{$PATH_TO_PHP}#{LIB}/") || (file.include? "#{$PATH_TO_PHP}#{SCRIPT}/")
            # /lib OR /script PHP File
            self.createFileLib(file)
            return
        elsif (file.include? "#{$PATH_TO_TESTS}#{LIB}/") || (file.include? "#{$PATH_TO_TESTS}#{SCRIPT}/")
            # /lib OR /script PHP File (Test)
            self.createFileLibTest(file)
            return
        elsif file.include? "#{$PATH_TO_PHP}#{@type}/helpers/"
            # Helper (Test)
            self.createHelper(file, File.dirname(file).sub("#{$PATH_TO_PHP}#{@type}/helpers/", ''))
            return
        elsif file.include? "#{$PATH_TO_TESTS}#{@type}/helpers/"
            # Helper (Test)
            self.createHelperTest(file, File.dirname(file).sub("#{$PATH_TO_TESTS}#{@type}/helpers/", ''))
            return
        else
            exitScript("\nCouldn't determine file type.\nPlease note that the file '\x1B[33m#{file}\x1B[0m' has already been created and will need to be deleted manually.")
        end
    end

    # Creates the Controller.
    # @param filename
    def createFileController(filename, route)
        className = ''
        route.split('/').each { |routeParameter|
            routeParameter[0] = routeParameter.upcase[0..0]
            className = "#{className}#{routeParameter}"
        }
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            file.puts "namespace #{@namespace};"
            file.puts ''
            file.puts '/**'
            file.puts " * @package #{@namespace}"
            file.puts ' */'
            file.puts "class #{className} extends #{@namespace}Base implements #{@namespace}Interface"
            file.puts '{'
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public static function init()'
            file.puts '    {'
            file.puts '    }'
            file.write '}'
        }
    end

    # Creates the .js (MIN) file.
    # @param filename
    def createFileJsMin(filename, route)
        jsObjectName = ''
        route.split('/').each { |routeParameter|
            routeParameter[0] = routeParameter.upcase[0..0]
            jsObjectName = "#{jsObjectName}#{routeParameter}"
        }
        File.open(filename, 'w') { |file|
            file.write "var #{@namespace}_#{jsObjectName}={}"
        }
    end

    # Creates the .js (DEV) file.
    # @param filename
    def createFileJs(filename, route)
        jsObjectName = ''
        route.split('/').each { |routeParameter|
            routeParameter[0] = routeParameter.upcase[0..0]
            jsObjectName = "#{jsObjectName}#{routeParameter}"
        }
        File.open(filename, 'w') { |file|
            file.puts "var #{@namespace}_#{jsObjectName} = {"
            file.write '}'
        }
    end

    # Creates the .less file.
    # @param file
    def createFileLess(file, route)
    end

    # Creates the PHPUnit Test.
    # @param filename
    def createFileTest(filename, route)
        className = ''
        group = @namespace
        route.split('/').each { |routeParameter|
            routeParameter[0] = routeParameter.upcase[0..0]
            className = "#{className}#{routeParameter}"
        }
        className = "#{className}Test"
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            file.puts "namespace #{@namespace};"
            file.puts ''
            file.puts 'use PHPUnit_Framework_TestCase;'
            file.puts ''
            file.puts '/**'
            file.puts " * @group #{group}"
            route.split('/').each { |routeParameter|
                routeParameter[0] = routeParameter.upcase[0..0]
                group = "#{group}/#{routeParameter}"
                file.puts " * @group #{group}"
            }
            file.puts " * @package #{@namespace}"
            file.puts ' */'
            file.puts "class #{className} extends PHPUnit_Framework_TestCase"
            file.puts '{'
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function setUp()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function tearDown()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function testSomething()'
            file.puts '    {'
            file.puts '        $this->assertTrue(true);'
            file.puts '    }'
            file.write '}'
        }
    end

    # Creates the View.
    # @param filename
    # @param route
    def createFileView(filename, route)
    end

    # Create file within /lib
    # @param filename
    def createFileLib(filename)
        className, namespace = getLibFileData(filename)
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            unless namespace.nil?
                file.puts "namespace #{namespace};"
                file.puts ''
            end
            file.puts '/**'
            if namespace.nil?
                file.puts " * Class #{className}"
            else
                file.puts " * @package #{namespace}"
            end
            file.puts ' */'
            file.puts "class #{className}"
            file.puts '{'
            file.write '}'
        }
    end

    # Create test for file within /lib
    # @param filename
    def createFileLibTest(filename)
        className, namespace = getLibFileData(filename)
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            unless namespace.nil?
                file.puts "namespace #{namespace};"
                file.puts ''
                file.puts 'use PHPUnit_Framework_TestCase;'
                file.puts ''
            end
            file.puts '/**'
            if namespace.nil?
                file.puts ' * @group Core'
            else
                file.puts " * @group   #{namespace}"
                file.puts " * @package #{namespace}"
            end
            file.puts ' */'
            file.puts "class #{className} extends PHPUnit_Framework_TestCase"
            file.puts '{'
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function setUp()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function tearDown()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function testSomething()'
            file.puts '    {'
            file.puts '        $this->assertTrue(true);'
            file.puts '    }'
            file.write '}'
        }
    end

    # Create Helper Class
    # @param filename
    # @param route
    def createHelper(filename, route)
        className, namespace = getLibFileData(filename, route)
        group = ''
        count = 0
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            file.puts "namespace #{namespace};"
            file.puts ''
            file.puts '/**'
            namespace.split("\\").each { |namespaceParameter|
                count = count + 1
                if count == 1
                    group = "#{namespaceParameter}"
                else
                    group = "#{group}/#{namespaceParameter}"
                end
                file.puts " * @group   #{group}"
            }
            file.puts " * @package #{namespace}"
            file.puts ' */'
            file.puts "class #{className}"
            file.puts '{'
            file.write '}'
        }
    end

    # Create Helper Class (Test)
    # @param filename
    # @param route
    def createHelperTest(filename, route)
        className, namespace = getLibFileData(filename, route)
        group = ''
        count = 0
        File.open(filename, 'w') { |file|
            file.puts '<?php'
            file.puts ''
            file.puts "namespace #{namespace};"
            file.puts ''
            file.puts 'use PHPUnit_Framework_TestCase;'
            file.puts ''
            file.puts '/**'
            namespace.split("\\").each { |namespaceParameter|
                count = count + 1
                if count == 1
                    group = "#{namespaceParameter}"
                else
                    group = "#{group}/#{namespaceParameter}"
                end
                file.puts " * @group   #{group}"
            }
            file.puts " * @package #{namespace}"
            file.puts ' */'
            file.puts "class #{className} extends PHPUnit_Framework_TestCase"
            file.puts '{'
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function setUp()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function tearDown()'
            file.puts '    {'
            file.puts '    }'
            file.puts ''
            file.puts '    /**'
            file.puts '     * @return void'
            file.puts '     */'
            file.puts '    public function testSomething()'
            file.puts '    {'
            file.puts '        $this->assertTrue(true);'
            file.puts '    }'
            file.write '}'
        }
    end

    # Extracts namespace + className from lib filename. Used internally.
    # @param filename
    # @param route
    def getLibFileData(filename, route = nil)
        fileSplit = nil
        if filename.include? "#{$PATH_TO_PHP}#{@type}/"
            fileSplit = filename.sub("#{$PATH_TO_PHP}#{@type}/", '')
        elsif filename.include? "#{$PATH_TO_TESTS}#{@type}/"
            fileSplit = filename.sub("#{$PATH_TO_TESTS}#{@type}/", '')
        else
            exitScript('Filesplit couldn\'t determine file type properly. This statement should never be reached.')
        end
        fileSplit = fileSplit.split('/')
        if @type == LIB
            if fileSplit[0].downcase != 'core'
                namespace = fileSplit[0].capitalize
            else
                namespace = nil
            end
        elsif @type == SCRIPT
            namespace = 'Script'
        else
            namespace = "#{@type.capitalize}"
            route.split('/').each { |routeParameter|
                namespace = "#{namespace}\\#{routeParameter.capitalize}"
            }
        end

        if @type == LIB || @type == SCRIPT
            className = File.basename(fileSplit[1], File.extname(fileSplit[1]))
            className[0] = className.upcase[0..0]
        else
            className = File.basename(filename, File.extname(filename))
            className[0] = className.upcase[0..0]
        end

        return className, namespace
    end
end