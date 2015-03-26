require 'watir-webdriver'
require 'uri'
require 'json'



def login(browser)
  signIn = {
    email: 'thewingedpharaoh@gmail.com',
    password: 'thisisafake'
  }
  browser.text_field(:id, 'email').set signIn[:email]
  browser.text_field(:id, 'pass').set signIn[:password]
  browser.button(:type, 'submit').click
end

def get_likes_metric(url)
    b = Watir::Browser.new
    b.goto url

    b.divs(class: "_50f6 _50f7 _5tfx").each do
     |div| puts div.text
    end
    b.close
end

def get_liked_pages(url)
    b = Watir::Browser.new
    b.goto url
    flag = 0

    #Works but next one works better
    #b.links(:class => "_g3j").each do |b|
    #   puts b.href  
    #end
    

    login(b)
    newurl = b.link(:class => "_g3j", :index => 5).href
    b.goto newurl
    parent_h = b.divs(:class => "fsl fwb fcb").find_all { |div| div.a.exists? }
    parent_h.each do |link|
        puts link.text
    end    
    #puts my_hdr.text
    #b.links.each do |link|
    #  puts link.text
    #end    
    b.close
end 


#test cases
get_likes_metric("https://www.facebook.com/mahjongtrails/likes")
get_liked_pages("https://www.facebook.com/candycrushsaga/")