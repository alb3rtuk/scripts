require 'json'

y = JSON.parse(`aws ec2 describe-regions`)

region_count = 0
region_sql = []

az_count = 0
az_sql = []




y['Regions'].each do |region|

    puts region.inspect
    region_count = region_count + 1
    region_sql << 'INSERT INTO client.data_center ('
    region_sql << '  id,'
    region_sql << '  data_center_code,'
    region_sql << '  data_center_name,'
    region_sql << '  end_point'
    region_sql << ') VALUES ('
    region_sql << "  '#{region_count}',"
    region_sql << "  '#{region['RegionName']}',"
    region_sql << "  '?',"
    region_sql << "  '#{region['Endpoint']}'"
    region_sql << ');'
    region_sql << ''

    az = JSON.parse(`aws ec2 describe-availability-zones --region #{region['RegionName']}`)
    az['AvailabilityZones'].each do |zone|
        puts zone.inspect
        az_count = az_count + 1
        az_sql << 'INSERT INTO client.data_center_availability_zone ('
        az_sql << '  id,'
        az_sql << '  data_center_id,'
        az_sql << '  availability_zone_code'
        az_sql << ') VALUES ('
        az_sql << "  '#{az_count}',"
        az_sql << "  '#{region_count}',"
        az_sql << "  '#{zone['ZoneName']}'"
        az_sql << ');'
        az_sql << ''

    end

end

region_sql.each do |line|
    puts "\x1B[38;5;68m#{line}\x1B[0m"
end

az_sql.each do |line|
    puts "\x1B[38;5;78m#{line}\x1B[0m"
end