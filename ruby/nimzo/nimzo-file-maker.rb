require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

# Accepts arrays of paths/files, determines what content they require and then creates those files.
class NimzoFileMaker

    # @param paths
    # @param files
    def initialize(paths = Array.new, files = Array.new, space = '')

        @paths = paths
        @files = files
        @space = space

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
        puts "          \x1B[0m#{path}\x1B[0m"

        # @todo FILE CREATE CODE goes here!

    end

    # @param files
    def createFiles(files = @files)
        unless files.kind_of?(Array)
            exitScript("Expected Array, you passed (#{files.class})")
        end
        unless files.empty?
            files.each { |file|
                puts "          \x1B[90m#{file}\x1B[0m"


                # @todo FILE CREATE CODE goes here!

            }
        end
    end

end