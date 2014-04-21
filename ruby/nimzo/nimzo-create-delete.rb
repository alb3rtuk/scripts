require '/Users/Albert/Repos/Scripts/ruby/lib/utilities.rb'
require '/Users/Albert/Repos/Scripts/ruby/lib/nimzo/nimzo.rb'

class NimzoCreateDelete

    def initialize(action, route, type)
        @action = action
        @route = route
        @type = type

        self.validateParameters
        self.validateRoute

    end

    def validateParameters

    end

    def validateRoute

    end

end

NimzoCreateDelete.new(ARGV[2], ARGV[0].sub(/^[\/]*/, '').sub(/(\/)+$/, ''), ARGV[1])