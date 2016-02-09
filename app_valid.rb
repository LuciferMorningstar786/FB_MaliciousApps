require 'koala'
require 'json'
@graph = Koala::Facebook::API.new("CAACEdEose0cBAI6ANFBEER1ZAquJoK6zNZBc6ZBZAhuMGHJA2sdZB5J1DIdkLgsODIgXE8HcPqiE7TdcyhD7kh6p8P1L7YvhAa9a8o2rtxNcENo7x6IdxcJQn6LjHGecbyJS5SHhrFUm7XY2ECiPld6AHSGUiFQHiTUX6J1VTyUjLWmkkPu7WZCrrKy9EmBMqCwPNNSHnNkQZDZD")

mylist = Array.new    

count = 0
File.open("app_list_zhuo.txt", 'a') do |f2|
   File.open('./Downloads/Final/Program/appid', 'r') do |f1|
	   while appid = f1.gets
#appid = "330096207098548";
		  appid.chomp!
		  begin
			content = @graph.get_object(appid)
			puts appid
			f2.puts(appid)
			count = count+1;
		  rescue Exception =>msg
			if msg.message.match("OAuthException")
				abort("Token expired")
			end	
		  end
	   end	
   end
end   

#puts "The number of existing apps are"
#puts count

