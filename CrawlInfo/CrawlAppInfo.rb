require 'Koala'
require 'json'
@graph = Koala::Facebook::API.new("CAACEdEose0cBAJC4aDET9bG2gAlStjTRZCQkFHPYyPlmC3xEuDAcsYtbeIYcz0goHwANL8KZAW0u7O9bWQS4ywbG17vANCqp5TXEzgsnpWsuDghZAE2OMjbwyPSVYdiz8vvgFQgUJSIHb8DChbRIRi73tjV9mlMKzVEqXt2KshpxzZAsfq2Yai7bZAZCpw5BIlg6pzvbjxoFZCEuZCeIvjiN")

def write_json_file(appid, content)
	puts filename = "./out3/"+appid+".json";
	File.open("#{filename}", 'w') do |f2|  
		f2.write(content.to_json)
	end
end

def getTopTenComment(posts, index)
	postComment = {};
	begin
		crawlNumber = 10;
		numComment = posts[index]["comments"]["data"].length
		i = 0
		postComment = {};
		while i<crawlNumber-1 && i < numComment-1 do
			comment = {};
			comment["user"] = posts[index]["comments"]["data"][i]["from"]["name"];
			comment["message"] = posts[index]["comments"]["data"][i]["message"];
			postComment["#{i}"] = comment;
			i = i +1;
		end
		
	rescue Exception => msg
		puts msg
	end
	return postComment;
end

#appid = "bubblewitchsaga2";

def get_app_info(appid)
	temp = @graph.get_object(appid);
	oup = {};

	##1. How many users like this app
	likeNum = temp["likes"]  # how many users like this app

	##2. How many users talking about this app
	talkingAbout = temp["talking_about_count"]  # how many users talking about this app

	##3. What apps be recommanded by this app
	begin
		itsLikes = @graph.get_object(appid+"/likes");
	rescue Exception =>msg
		itsLikes = "none" # msg
	end 
	##4. How many posts this app page have
	postResult = {};
	postNum = 0;
	begin
		posts = @graph.get_object(appid+"/posts?limit=250")
		count = 0;  # Number of posts
		begin
			if count != 0
				a = posts.paging["next"].gsub("https://graph.facebook.com/","")
				posts = @graph.get_object(a)
			end
			count = count + posts.length
		end while (not posts.paging.nil?) && (not posts.paging["next"].empty?)
		# puts "###################"
		postNum = count;

		posts = @graph.get_object(appid+"/posts")
		postslength = posts.length;
		numCrawl = 10;
		index = -1;
		
		while postslength > 0 && numCrawl >0 do
			postslength = postslength -1;
			numCrawl = numCrawl - 1;
			index = index +1;
			##5. post Share number
			postShares = posts[index]["shares"]["count"]

			##6. How many likes on one specific post (first post is considered here)
			postLike = posts[index]["likes"];
			postLikeNum = postLike["data"].length
			
			post = {};
			post["shares"] = postShares;
			post["likes"] = postLikeNum;
			post["message"] = posts[index]["message"]
			post["comments"] = getTopTenComment(posts,index)
			postResult["#{index}"] = post;
		# puts "$$$$$$$$$$$$$$$$$$$$$$$$$";
		# count = 0
		# begin
		   # if count != 0
				# a = postLike["paging"]["next"].gsub("https://graph.facebook.com/","");
				# puts a = a.gsub("v2.0/","v2.3/");
				# postLike = @graph.get_object(a)
		   # end
		   # puts postLike;
		   # puts count = count + postLike["data"].length
		   # count = count + postLike["data"].length
		# end while (not postLike["paging"].nil?) && (not postLike["paging"]["next"].empty?)
		# puts "###################"
		# puts postLikeNum = count
		end
	rescue Exception=>msg
		#puts msg
		#postNum = 0;
	end

	## Collect information
	oup["userLikes"] = likeNum;
	oup["talingAbout"]= talkingAbout;
	oup["itsLikes"] = itsLikes;
	oup["postNum"] = postNum;
	oup["postTop10"] = postResult;
	return oup
end

count = 0;
File.open('./newapps/urllist_appdata_3.txt', 'r') do |f1|
	while line = f1.gets
		appid = line.gsub("http://www.facebook.com/apps/application.php?id=", "")
		#appid = "330096207098548";
		appid.chomp!;
		begin
			content = get_app_info(appid)
			#puts appid
			write_json_file(appid,content);
			count = count+1;
		rescue Exception =>msg
			puts msg
		end
	end
end
puts "The number of existing apps are"
puts count

=begin

# put results into output hash table

oup[appid][:likeNum] = likeNum;
oup[appid][:talkingAbout] = talkingAbout;
oup[appid][:itsLikes] = itsLikes;
oup[appid][:postNum] = postNum;
oup[appid][:firstPostLikes] = firstPostLikes;
oup[appid][:firstPostComments] = firstPostComments;

#puts likeNum = temp["monthly_active_users_rank"]
#photos = @graph.get_object("bubblewitchsaga2/photos"); puts num = photos[0]["id"];


puts oup

File.open("./temp.json","w") do |f|
  f.write(oup.to_json)
end
=end
