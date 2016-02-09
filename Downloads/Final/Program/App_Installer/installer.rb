require 'watir-webdriver'
require 'uri'
require 'cgi'
require 'json'

def login(browser)
  # login facebook
  signIn = {
    email: 'thirdmostfake@gmail.com',
    password: 'oogabooga'
	#email: 'thewingedpharaoh@gmail.com',
	#password: 'thisisafake'
	#email: 'unholymolyrolypoly@gmail.com',
  #password: 'biggoodsheep'
   #email: 'rumpelinthejungle@gmail.com',
   #password: "that'swhatshesaid"
     }
  login_url = 'https://www.facebook.com'  

  browser.goto login_url
  browser.text_field(:id, 'email').set signIn[:email]
  browser.text_field(:id, 'pass').set signIn[:password]
  browser.button(:type, 'submit').click

  #if browser.text.include? 'Steve Zhang'
  if browser.text.include? 'Fakity'
    puts '****Login successfully'
  else
    puts '****Error in Login'  
  end
end


if __FILE__ == $0
  browser = Watir::Browser.new
  login(browser)

  # install apps
  count = 0
  # read app list
  app_list = File.open(File.expand_path('~/Documents/FB_apps/Non_game_apps'))
  #app_info = File.open('app_info2.json', 'w')
  #res = []
  
  while !app_list.eof?
    app_url = "apps.facebook.com/"+app_list.readline
    #app_url = 'www.facebook.com/apps/application.php?id=210831918949520' # play game
    #app_url = 'www.facebook.com/apps/application.php?id=191522367545899' # like
    #app_url = 'www.facebook.com/apps/application.php?id=65496494327' # write/read auth
    #app_url = 'http://www.facebook.com/apps/application.php?id=178134238871931'
	  
    #record = {}
  # get app id
    #app_id = CGI.parse(URI.parse(app_url).query)['id'][0]
    #record['id'] = app_list.readline
    #puts app_url
    abort "Done" if [count,100].min==100    
    begin 
	  Timeout::timeout(30) do
	    browser.goto app_url				
      end
    rescue Exception => e
      puts e
	    next
    end    
	

  
	# parse url to get redirect_uri and permissions	
   ''' 
    begin
	    params = CGI.parse(URI.parse(browser.url).query)
	    redirect_uri =  params[redirect_uri][0]
	    perms = params[scope][0].split(",")
	    record[redirect_uri] = redirect_uri
	    record[permissions] = perms
		
	    puts perms[0]	
      count = count+1
    rescue Exception => e
      puts e
      puts "Oh well!"
      next
    end     
	res.push(record)
	app_info.write(res)
	
	#break
	'''


    # read/write auth
    while browser.button(:text, 'Play Now').exists?
	   begin 
	    Timeout::timeout(30) do
          browser.button(:text, 'Play Now').click
          sleep 10		  
	    end
        count+=1
        if [count,100].min == 100
        	abort "Done"
        end
	   rescue Exception => e
	  	puts e
	    puts 'time out on click'
      next
	   end
    end


    while browser.button(:name, '__CONFIRM__').exists?
	   begin 
	    Timeout::timeout(30) do
          browser.button(:name, '__CONFIRM__').click	
          sleep 30	  
	    end
        count+=1
        if [count,60].min == 60
        	abort "Done"
        end
	   rescue Exception => e
	  	puts e
	    puts 'time out on click'
      next
	   end
    end
  end	 	

  # write to json file

 # app_info.write(res.to_json)
 # puts res
 # sleep 30
  # close app list
  app_list.close
 # app_info.close
  
end

