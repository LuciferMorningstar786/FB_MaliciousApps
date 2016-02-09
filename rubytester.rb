require 'json'
require 'fuzzystringmatch'
require 'decisiontree'
#what are you returning??

# process inputs into some form and feed them into classifier

$training = Array.new

def post_processor(var = 0)
	my_arr = Array.new
	begin 
	  avg_ascii = max_sim = avg_sim = avg_smileys = avg_unicode = 5
	  my_arr<<avg_ascii<<max_sim<<avg_sim<<avg_smileys<<avg_unicode<<var
	rescue => e
	  puts e
	end
	puts my_arr    
	$training<<my_arr
end	


def train()
		post_processor(1)			
	
end	

def main()
	train()
end	

main()