require 'koala'

@graph = Koala::Facebook::API.new("CAACEdEose0cBAAwh2xh27yWDXZAOqF7e0bShVBB9cLkiQyrRoN06vZA3CO1R97JkiSUPfyIeuqj68cAwt7LrVHO9JYgRz5wifiyZBYFCoaFR7NnZC7ys25SFKhXprVXJ0rciETU9QG4rHXgEEI4ngZA3FeoTHzoI2NmnumLBugFzZBgEnpdF71ZB05JphE22c5lJyMnZAkVGiXJUt6AxjScj")

appcount = pagecount = 0


#f1 = File.open("only_apps.txt","a");
f2 = File.open("only_pages.txt","a");

File.open(File.expand_path('~/app_list_zhuo_sorted.txt')) do |f|
	while line = f.gets
		line = line.chomp
		#begin
		#	data = @graph.get_object(line.to_s+"?fields=monthly_active_users")
		#	appcount = appcount+1
		#	puts data
		#	f1.puts(line) 
		#	next  
		#rescue Exception => e
		#    puts e	
		#end
		begin
			puts line
			data = @graph.get_object(line.to_s+"?fields=talking_about_count")
		    pagecount = pagecount+1
		    puts data
		    f2.puts(line)
		    
		rescue
		    next	     
		end
	end
end

puts pagecount
#puts appcount