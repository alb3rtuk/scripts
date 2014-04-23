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
        unless File.directory?(path)
            puts " \x1B[32mCreated:\x1B[0m \x1B[90m#{path.sub("#{$PATH_TO_PHP}/", '')[0..-1]}\x1B[0m"
            FileUtils::mkdir_p(path)
        end
    end

    # @param files
    def createFiles(files = @files)
        unless files.kind_of?(Array)
            exitScript("Expected Array, you passed (#{files.class})")
        end
        unless files.empty?
            files.each { |file|
                puts " \x1B[32mCreated:\x1B[0m \x1B[0m#{file.sub("#{$PATH_TO_REPO}/", '')[0..-1]}\x1B[0m"
                self.createPath(File.dirname(file))
                File::new(file, 'w')
                # Add file to Git.
                system ("cd #{$PATH_TO_REPO}")
                system ("git add #{file.sub("#{$PATH_TO_REPO}", '')[1..-1]}")
            }
        end
    end

end