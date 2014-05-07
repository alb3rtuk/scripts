require '/Users/Albert/Repos/Nimzo-Ruby/lib/core/Routes.rb'

class DisplayRoutes

    # @param type
    def initialize(type)
        unless type.nil?
            @types = Array[type]
        else
            @types = Array['modal', 'overlay', 'page', 'system', 'widget']
        end
        routes = Routes.new
        @types.each { |type|
            puts
            puts "  \x1B[36m#{type.upcase}\x1B[0m"
            routes.getRoutesForType(type).each { |route|
                puts "  \x1B[90m#{route}\x1B[0m"
            }
        }
        puts
    end

end

DisplayRoutes.new(ARGV[0])