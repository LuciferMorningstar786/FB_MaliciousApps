require 'koala'

@graph = Koala::Facebook::API.new("CAACEdEose0cBAEh2FiISiJ3E98ACbFXjzjSugu4qHCNMtLbQ9jmWkms7NNshCuWJzjomiYT0GNIFcPkXjXWGXc4ZCSAKZBUMG3yqJdUliOinWGt9BELZC03ykw6VnY47cIiaTqyUi3pLtfnZAnaKEfSkais5RRFKJgRwZBOQdyUf4hFRZAY4VzuReXEDiZCuZCzH4x540tUkjpzcX3JO2kKs")




fout = File.open("mal_pages_as_ids.txt", "w")
File.open('known_mal_pages.txt') do |f|
	while line = f.gets
		line = line.chomp
		begin
                        temp = @graph.get_object(line)
			target = temp["id"]
                        fout.puts(target)
		rescue Exception	
			puts line
		    	next	
		end
	end
end

fout.close
