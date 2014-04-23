require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

class NimzoRewriter

    # Determines the route on instantion.
    def initialize(type)

        # Make sure the particular controller type is valid.
        # This error cannot be reached through incorrect user input.
        unless inArray(%w(app modal overlay system widget), type)
            puts("\x1B[33m#{@type}\x1B[0m is not a valid controller type. There is an error in your bash script, not your input.")
            exit
        end

        @type = type.downcase
        @routes = Array.new

        # Get all the routes (for this content type).
        paths = Dir.glob("#{$PATH_TO_PHP}#{@type}/controllers/**/")
        paths.each { |route|
            route = route.sub("#{$PATH_TO_PHP}#{@type}/controllers/", '')[0..-2]
            unless route == ''
                @routes.push(route)
            end
        }

        self.rewriteLess
        self.rewriteReferences

    end

    # Re-write import-*.less file.
    def rewriteLess
        File.open("#{$PATH_TO_DEV}lib/less/imports/import-#{@type}.less", 'w') { |file|
            count = 0
            @routes.each { |route|
                filename = ''
                route.split('/').each { |routeParameter|
                    routeParameter[0] = routeParameter.upcase[0..0]
                    filename = "#{filename}#{routeParameter}"
                }
                filename[0] = filename.downcase[0..0]
                importLess = "@import '../../../#{@type}/#{route}/#{filename}';"
                count = count + 1
                if count < @routes.size
                    file.puts importLess
                else
                    file.write importLess
                end
            }
        }
    end

    # Re-write (App, Modal, Overlay, System, Widget) reference file.
    def rewriteReferences
    end

end

if ARGV[0] == 'rewrite'
    if ARGV[1] != nil
        NimzoRewriter.new(ARGV[1])
    else
        NimzoRewriter.new('app')
        NimzoRewriter.new('modal')
        NimzoRewriter.new('overlay')
        NimzoRewriter.new('system')
        NimzoRewriter.new('widget')
    end
end