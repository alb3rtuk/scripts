require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

class NimzoGenertateSleekTestValidator

    # @param className
    def initialize(className)

        className = className.sub(/^[\/]*/, '').sub(/(\/)+$/, '').squeeze('/')
        className = className.dup.split('.')
        className = className[0]

        # Validate that the string passed is AlphaNumeric
        unless isAlphaNumeric(className.gsub('_', ''))
            self.error("\x1B[33mClassname\x1B[0m must be alphanumeric. You passed: \x1B[33m#{className}\x1B[0m")
        end

        fileName = "#{className.dup}.php"
        fileName[0] = fileName[0..0].upcase
        fileLocation = Dir.glob("#{$PATH_TO_PHP}**/#{fileName}")

        # Validate that the file even exists & that there is ONLY 1!
        if fileLocation.size === 0
            self.error("No file(s) found for class '\x1B[33m#{className}\x1B[0m'. Check your capitilaztion, search is case-sensitive.")
        elsif fileLocation.size > 1
            self.error("More than 1 file found for class '\x1B[33m#{className}\x1B[0m'")
        end

        puts fileLocation[0]

    end

    # Die on error.
    # @param text
    def error(text = '')
        puts
        puts "\x1B[41m ERROR \x1B[0m #{text}"
        puts "        \x1B[90mScript aborted.\x1B[0m"
        puts
        exit 1
    end
end

NimzoGenertateSleekTestValidator.new(ARGV[0])