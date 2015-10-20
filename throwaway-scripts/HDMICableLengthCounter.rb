lengths = ['3m', '7m', '7m', '10m', '10m', '1m', '15m', '1m', '1m', '3m', '5m', '2m', '15m', '3m', '5m', '10m', '5m', '2m', '5m', '2m', '15m', '2m', '1m', '5m', '1m', '1m', '1m', '10m', '3m', '5m', '5m', '2m', '2m', '5m', '20m', '3m', '10m', '15m', '15m', '5m', '5m', '1m', '5m', '5m', '1m', '15m', '20m', '5m', '15m', '20m', '20m', '10m', '5m', '15m', '5m', '10m', '2m', '5m', '7m', '10m', '2m', '1m', '5m', '5m', '1m', '3m', '1m', '2m', '1m', '20m', '1m', '10m', '10m', '20m', '1m', '2m', '3m', '7m', '2m', '3m', '10m', '7m', '3m', '7m', '2m', '15m', '5m', '10m', '3m', '3m', '2m', '5m', '1m', '1m', '2m', '2m', '15m', '1m', '1m', '2m']

count = {}

lengths.each do |x|
    if count[x].nil?
        count[x]=0
    else
        count[x]=count[x]+1
    end
end

puts count.inspect


# {"3m"=>10, "7m"=>5, "10m"=>11, "1m"=>18, "15m"=>9, "5m"=>19, "2m"=>15, "20m"=>5}

x = {
    "1m" => 18,
    "2m" => 15,
    "3m" => 10,
    "5m" => 19,
    "7m" => 5,
    "10m" => 11,
    "15m" => 9,
    "20m" => 5
}