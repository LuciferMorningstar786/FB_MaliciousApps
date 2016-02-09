require 'koala'

@graph = Koala::Facebook::API.new("CAACEdEose0cBAF1nr1UQwTQb80CK5iuj13vjpIHHQru1P14FP73MINyBZCy4G0OgLhJCKXPniG2V6bAPeSDN78cMqVGZBm1mHVz5wxlhdK2yJNlMGq0tlTWQv64VtVV7oOiY1KwFZAZBHjQ6Ky8wQyaid2oER5oEkVFHxWc9MVEbdlIgWeQBSdqcUQRPmk6eOYY7WQppnZA54Vj3zosjs")

appcount = pagecount = 0



my = 0

File.open(File.expand_path('~/Documents/FB_apps/appdata_urls.txt')) do |f|
	while line = f.gets
		line = line.chomp
		Dir.chdir("app_fields") do 
			begin
				link_and_nshash = Hash.new
				data = @graph.get_object(line.to_s+"?fields=app_name,app_type,id,monthly_active_users,daily_active_users,auth_dialog_headline,auth_dialog_perms_explanation,auth_referral_enabled,auth_referral_extended_perms,auth_referral_friend_perms,auth_referral_user_perms,canvas_fluid_width,canvas_url,company,context,created_time,daily_active_users_rank,deauth_callback_url,description,hosting_url,icon_url,link,logo_url,mobile_web_url,monthly_active_users_rank,object_store_urls,page_tab_url,privacy_policy_url,restrictions,server_ip_whitelist,social_discovery,supported_platforms,user_support_email,user_support_url,website_url,weekly_active_users,subcategory,namespace")
				outFile = File.open("#{line}","w")
				link_and_nshash[line] = data
				appcount = appcount+1
				outFile.puts(link_and_nshash)
				outFile.close
			rescue Exception	
				puts line
		    	next	
			end
		end
	end
end
