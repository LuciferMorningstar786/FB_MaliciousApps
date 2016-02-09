require 'koala'

@graph = Koala::Facebook::API.new("CAACEdEose0cBALVJfZBFxrRpzKOx5ZAfj7xJp4YFbTeFh2yLBqPfZCMijyXWnwRZCXZA6SpA0MO9YIkZAFHhvdEYtDAmXgxsvlScUFiOBlOZCwdaPoEOYQDZB6AaqYVrFH6eD7h2k2fC1ZCRLJrC7ieAULZAzwQtGZAky6XYYzH8ZANIvXi5HCIW1O88jkDQSUyUSOjMD1dpEVMUNt0fTWDLP2wA")

outFile = File.open("Non_game_apps","w")

File.open(File.expand_path('~/Documents/FB_apps/appdata_urls.txt')) do |f|
	while line = f.gets
		line = line.chomp
		begin
				data = @graph.get_object(line.to_s+"?fields=category")
				#puts data["category"] unless data["category"] == "Games"
				outFile.puts(line) unless data["category"] == "Games"
		rescue Exception => e 
				puts " #{e}for #{line}"
		    	next	
			
		end
	end
end

outFile.close