require 'csv'

export_types = []

json = []

CSV.foreach(File.path(File.expand_path('~/export.csv'))) do |row|

    export_types << row[0]

    if row[0] == 'Order'

        json << '    {'
        json << "       \"field\": \"#{row[2]}\","
        json << "       \"displayName\": \"#{row[1]}\","
        json << "       \"type\": \"\""
        json << '    },'

    else

        puts row.inspect

    end

end

puts

puts export_types.uniq!

json.each do |line|
    puts line
end