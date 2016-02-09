require 'koala'
require 'json'

@graph = Koala::Facebook::API.new("CAACEdEose0cBAJ8u5GAqREVZCAtlgH3Usy89ZACTdZBAwK3mOFWVCvxYmp77uaX4hKBq22oWuvNzTZAUv2wY5KK5s3obxMLZB8qYUGH81dAlOh1DjRf68c8Lmz3Iaosdi8WCmCi7zYxiRlzB6nsqF02ZBSiZB6o9Mx83Qk4vIiRucackQXt39wfCP9gpE5xeMSGZCVElX3pU8SDvSMJtK2Ty")

f1 = File.open("crawled_pages.txt","w")

File.open("fb_pages.txt") do |f|
    while line = f.gets
         obj=line.chomp!
         begin
             liked_pages = @graph.get_object(obj+"/likes")
	    # puts "Success for #{obj}"
	    # puts liked_pages
             (0..liked_pages.length-1).each do |i|
 	            f1.puts liked_pages[i]["id"]
	     end
	 rescue Exception => e
            # puts "#{e.message}"
            # puts "Failed on #{obj}"
         end
         begin
             posts = @graph.get_object(obj+"/posts")
             puts "Success for #{obj}"
         rescue Exception => e
             puts "Failed on #{obj} with message #{e.message}"
         end
    end
end

             
