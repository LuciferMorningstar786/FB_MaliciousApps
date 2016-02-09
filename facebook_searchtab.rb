require 'watir-webdriver'
require 'watir-scroll'

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

#	words = ["game hacks", "free food", "free coupons", "free samples", "ios game hacks", "android game hacks", "warez", "facebook color change", "dislike button", "free ipad", "free phone", "who removed me", "who deleted me", "free file sharing application", "download free pc games", "download movie full", "free movie download", "star wars the force awakens", "photo magic", "free games store", "free music", "clearance", "gift card", "gift certificate", "free website", "free membership","free merchandise","unfriend","popular","ultimate","merry christmas","football","facebook","install facebook colors","facebook colors","facebook video","celeb photos","hot photos","hot girls","fit girls","lose weight","free installation","special promotion","giveaway","work at home","extra income","one time","marketing","bargain","potential earnings","please read","full refund","credit card","online pharmacy","promotional","all natural","risk free","wrinkle removal","free insurance","amazing offer","credit bureau","join millions","cheap vacation","search engine","shopping spree","lose weight","time limited","vicodin","free gift","who wins","cure baldness","rolex","reverse aging","Facębook Reçovęry","profile view","my best photo","unfriend finder","who blocked me","what character are you","what is your name"]

	words = ["Facębook Reçovęry","profile view","my best photo","unfriend
	finder","who blocked me","what character are you","what is your name"]

	browser = Watir::Browser.new
	login(browser)
	myLinks = Array.new
	#words.each do |word|
	#	word.gsub! ' ', '%20'
	#end
	base_url = 'https://www.facebook.com/search/pages/?q='
	words.each do |url|
        	total_url = base_url + url
                browser.goto total_url
		
		loop do
 	         	 link_number = browser.links.size
  		         browser.scroll.to :bottom
                         browser.driver.manage.timeouts.implicit_wait = 20
  		         break if browser.links.size == link_number
	        end
		browser.links(:href, /www.facebook.com\/.+\/?ref=br_rs$/).each do |brow|
			myLinks.push(brow.href)
		end 
	end
	f = File.open("extra_pages.txt",'w')
	myLinks.each do |m|
	    f.puts(m)
	end
	puts myLinks
        browser.close()

end

main()
