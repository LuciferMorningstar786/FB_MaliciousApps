'''
Need to split list into smaller chunks so I can retrieve the data

'''


require 'watir-webdriver'
require 'uri'
require 'json'
require 'watir-scroll'

$prob_list = []

def write_to_file(id, data)
   Dir.chdir(File.dirname(__FILE__)+"/specs")
   filename = "./"+id+".json"
   File.open("#{filename}", 'w') do |f2|  
    f2.write(data.to_json)
   end   
   Dir.chdir ".."
end

def login(browser)
  signIn = {
    email: 'thirdmostfake@gmail.com',
    password: 'oogabooga'
  }
  browser.text_field(:id, 'email').set signIn[:email]
  browser.text_field(:id, 'pass').set signIn[:password]
  browser.button(:type, 'submit').click
end

def get_likes_metric(id)  #Works as of 4/9
    b = Watir::Browser.new
    url = "www.facebook.com/"+id.to_s
    begin
      b.goto url
      login(b)
      b.link(class: "uiLinkSubtle").click
      sleep 3
      puts b.div(:class => "_50f6 _50f7 _5tfx", :index => 0).text
      puts b.div(:class => "_50f6 _50f7 _5tfx", :index => 2).text  
      # puts "found result!\n"
      
      puts b.span(:class => "_5cup", :index => 0).text  
      puts b.span(:class => "_5cup", :index => 1).text  
      file_hash = {}
           
      #out1 = b.span(:class => "_5cup", :index => 0).text.sub(/^[0-9.]/, "")
      #out2 = b.span(:class => "_5cup", :index => 1).text.sub(/^[0-9.]/, "")
      #print out1
      #print out2
      file_hash["PTAT"]=b.div(:class => "_50f6 _50f7 _5tfx", :index => 0).text
      file_hash["Newlikes"]=b.div(:class => "_50f6 _50f7 _5tfx", :index => 2).text  
      file_hash["ChangeInLikes"]=b.span(:class => "_5cup", :index => 0).text  
      file_hash["ChangeinNewLikes"]=b.span(:class => "_5cup", :index => 1).text  
      write_to_file(id, file_hash)
      print "Done!\n\n"
      b.close()
      $prob_list << id

    rescue Exception => msg
      puts msg
      print id
      b.close    
    end  


end

#print Dir.pwd
url = File.open("newapps/curlist.txt","r")
url.each_line do |line|
  #id = /[\d]+/.match(line)
  get_likes_metric(line)
end 

print $prob_list  

'''
#  #test cases
get_likes_metric(280034132055819)
'''