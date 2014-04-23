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

        @type = type
        @route = ''


        puts "ROUTE: \x1B[35m#{@route}\x1B[0m"

        self.rewriteLess
        self.rewriteReferences

    end

    # Re-write import-*.less file.
    def rewriteLess
    end

    # Re-write (App, Modal, Overlay, System, Widget) reference file.
    def rewriteReferences
    end

end

if ARGV[0] == 'rewrite'
    NimzoRewriter.new($1)
end