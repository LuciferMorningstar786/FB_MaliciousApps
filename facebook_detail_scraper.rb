require 'watir-webdriver'
require 'watir-scroll'
require 'koala'
require 'json'

def login(browser)
	signIn = {
		 email: 'thewingedpharaoh@gmail.com',
		 password: 'thisisafake'
		 }
	login_url = 'www.facebook.com'
	browser.goto login_url
    browser.text_field(:id, 'email').set signIn[:email]
    browser.text_field(:id, 'pass').set signIn[:password]
	browser.button(:type, 'submit').click
end


def main()

        @graph = Koala::Facebook::API.new("CAACEdEose0cBAEh2FiISiJ3E98ACbFXjzjSugu4qHCNMtLbQ9jmWkms7NNshCuWJzjomiYT0GNIFcPkXjXWGXc4ZCSAKZBUMG3yqJdUliOinWGt9BELZC03ykw6VnY47cIiaTqyUi3pLtfnZAnaKEfSkais5RRFKJgRwZBOQdyUf4hFRZAY4VzuReXEDiZCuZCzH4x540tUkjpzcX3JO2kKs")
	browser = Watir::Browser.new
	login(browser)
	myLinks = Array.new
        f2 = File.open('bad_pages_extra.txt','a')
	base_url = 'https://www.facebook.com/'
	File.open("mal_pages_as_ids.txt") do |f|
           while line = f.gets
             line.chomp!
             fout = File.open("#{line}.json",'w')
             total_url = base_url+line 
             browser.goto total_url
             outputHash = Hash.new
	     begin
	        x = line.to_s+"/likes" 
	        pages_liked = @graph.get_object(x)
                (0..pages_liked.length-1).each do |li|
                    f2.puts(pages_liked[li]["id"])
                end
                outputHash["pages_liked"]=pages_liked
             rescue Exception => e
                puts "Error: #{e.message} for #{line} in likes"
             end

             begin
	        posts = @graph.get_object(line.to_s+"/posts")
		#puts posts
                outputHash["posts"] = posts
             rescue Exception => e
                puts "Error: #{e.message} for #{line} in posts"
             end
             begin
                 website_url = browser.a(:class => "_2kcr _42ef").text
                 outputHash["website_url"] = website_url
             rescue
             end
             begin
                browser.goto browser.url+"likes"
	        myArr=Array.new
                browser.divs(:class => "_50f6 _50f7 _5tfx").each do |d|
                     myArr.push(d.text)
                end
                x = Hash[(0..myArr.size).zip myArr]
                outputHash["like_variations"] = x
             rescue
             end   
             fout.puts(outputHash.to_json)
             fout.close
	     puts website_url
             puts x
           end   
	                 
	end
 
        browser.close             
end

main()
