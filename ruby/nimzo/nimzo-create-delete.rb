require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/nimzo/nimzo.rb'

class NimzoCreateDelete

    def initialize(action, route, type)
        @action = action
        @route = route
        @type = type

        @errors = false
        @output = Array.new

        self.validateParameters
        self.validateRoute
        self.run

    end

    def run
        if @output.empty?
            puts "No errors!"
        else
            puts @output.inspect
        end
    end

    def validateParameters

        @output.push('testing 1 2 3')

    end

    def validateRoute

    end

end

NimzoCreateDelete.new(ARGV[2], ARGV[0].sub(/^[\/]*/, '').sub(/(\/)+$/, ''), ARGV[1])