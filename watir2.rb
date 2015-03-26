require 'watir-webdriver'
require 'uri'
require 'cgi'
require 'json'
require 'set'
require 'timeout'
require_relative 'watir3'

#generate powerset of a string ie. from "A big boy" => "A","big","Boy","A,big","A,boy","big,boy"A,big,boy"
def Powerset(set) 
    ret = set.class[set.class[]]
    set.each do |s|
        deepcopy = ret.map { |x| set.class.new(x) }
        deepcopy.map { |r| r << s }
        ret = ret + deepcopy
    end
    return ret
end


def get_specs(string)
#generate array from the string input(string is the name of the app)
  new_str=string.split(" ")
  len=new_str.length  
  power=new_str.to_set
  a=Powerset(power)
#This generates all possible ordering of the sets in the powerset eg. at length 3, "A,big,boy", "A,boy,big", "Big,a,boy", "big,boy,a", etc.
#this lets me go to the app page which has all the likes. etc.
  for s in a
    s=s.to_a
    b=s.permutation.to_a
    for x in b
        mystring=String.new 
        for z in x
          mystring<<z
        end  
        #print mystring  
        #this is where I need to edit based on what I'm looking to extract
        login_url='https://www.facebook.com/'+mystring+'/likes'
        print login_url
        print "\n"
        #for each combination of the words in the app, spawn a new browser instance and try to reach the target page. If it doesn't work,
        #close it and try the next one. Very inefficient.
        browser=Watir::Browser.new
        begin
          Timeout::timeout(30) do
            login(browser,login_url)
          end  
        rescue Timeout::Error => msg
          puts "Unable to reach "+ login_url + " ! due to "
          next
          
        else
          print "Success in reaching "+ login_url + " !\n"
          
          browser.close
        end   
    end
    print "\n"  
  end
end


#login using fake account and try to visit each page
def login(browser,login_url='')
  # login facebook
  signIn = {
    email: 'thewingedpharaoh@gmail.com',
    password: 'thisisafake'
  }
  puts "Going to the new location login_url = #{login_url}"
  url='https://www.facebook.com'+login_url
  browser.goto login_url
  
  return unless not(browser.text.include? "Sorry, this page isn't available")

  browser.text_field(:id, 'email').set signIn[:email]
  browser.text_field(:id, 'pass').set signIn[:password]
  browser.button(:type, 'submit').click
#If we are on the app page this string is on the page  
  if browser.text.include? "App Page"
    #insert something done in watir3
     print "-------------------SUCCESS------------------\n"
  end  
  
end


if __FILE__ == $0
  app_names=File.read('app_information_full.json')
  data_hash=JSON.parse(app_names)
  #print data_hash[1]["name"]
  i=0
  while data_hash[i]
    get_specs(data_hash[i]["name"])
    i=i+1
  end  
end
