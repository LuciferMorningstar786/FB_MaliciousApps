require 'json'
require 'fuzzystringmatch'
require 'decisiontree'
require 'rubygems'
require 'ai4r'

#what are you returning??

# process inputs into some form and feed them into classifier
#avg_ascii<<max_sim<<avg_sim<<avg_smileys<<avg_unicode<<dataHash[k][0]<<dataHash[k][1]<<dataHash[k][2]
$labels = ["Average_Ascii", "Max_Similarity", "Average_Similarity", "Average_Smileys","Average_Unicode","Average_Story","PTAT", "Total_Page_Likes","New_Likes", "Malicious_or_Not"]
$training = Hash.new
$test = Hash.new

def download_extractor(input)
#get zips, rars, exes, 
	puts "Entered download_extractor"
	begin
		input.each do |p|
			out = p["message"].scan('\b(.*\.(?:zip|rar|exe|html))\b').size
			#puts out if out!=0
		end
	rescue => e
	end		


end


def unicode_checker(input)
	avg = 0
	input.each do |lol|
		begin
			succ = lol["message"].scan(/[^\P{L}a-zA-Z0-9]/).size
			#puts lol["message"] if succ!=0
			#puts "Done"
			avg += succ/(lol["message"].length) if lol["message"].length
		rescue => e
			next
		end
	end
	p avg
	return (avg/input.length)

end	

def smiley_counter(input)
	max = avg = 0
	input.each do |p|
	    count = 0
	    begin
	   		succ=p["message"].scan(/(?:[3O>]?)\:(?:(?:[\)PDO*\\\|\3])|(?:'\())|(<3)|(o.O)|(^.^)|(;\))|(8(?:-\)|\|)){1,}/).size
	        max = succ if succ>max
	        avg += succ/(p["message"].length) if p["message"].length
	    rescue => e
	    	next
	    end	    
	end

	avg = avg/(input.length)	
	#p avg
	return avg
end	

def ascii_checker(input)
	avg = 0
	input.each do |p|
		count = 0
		begin
			p["message"].chars do |m|
				unless m.ascii_only?
                    count+=1
                end    
			end
			avg += count/(p["message"].length) if p["message"].length
		rescue => e
			next
		end
		#puts "#{count} #{p["message"].length}"
	end	
	#p avg
	if input.length
	  return avg/input.length
	else
	  return 0
	end    

end

def calc_similarity(input)
	jarow = FuzzyStringMatch::JaroWinkler.create( :pure )
	max = 0
	avg = 0
	input.each_with_index do |c, ind1|
	   input.each_with_index do |d, ind2|
	   	 begin 
	   	  if ind1 == ind2
	   	     #puts "#{ind1} #{ind2}"
	   	     next
	      else
	         now = jarow.getDistance(c["message"],d["message"])
	         if now > max
	         	max = now 
	         end	  
	         avg += now/([c["message"].length, d["message"].length].max)
	         #if now == 1
	         #	puts c["message"]. d["message"]
	         #end	
	      end
	     rescue => e
	       next
         end
       end
    end   
    if input.length
    	avg = avg / input.length
    end	
    #puts max, min
    return max, avg
end

def story_examiner(input)
	avg = 0
	input.each do |l|
	  begin  
		  avg+=l["story"].length
	  rescue => e
	    next
	  end  
	end  
	if input.length  	
		avg/=input.length
	end	
	return avg
end	

def post_processor(dataHash, f, state = "test", var = 0)
	#p state if state == "test"
	unless f.is_a?(Integer)
		#puts state, f
		f.to_i
		#puts f
	end	
	outHash = Hash.new
	my_arr = Array.new
	#reorder these with a begin rescue for each
	begin
	  dataHash.keys.each do |k|
		if k == "posts"
		  begin	
			avg_ascii = ascii_checker(dataHash[k])
		  rescue
		  	avg_ascii = 0	
			#{}"ascii worked"
		  end
		  begin	
			max_sim, avg_sim = calc_similarity(dataHash[k])
			#p "MAX SIM = #{max_sim} AVG SIM = #{avg_sim}"
		  rescue
		    max_sim, avg_sim = 0
		  end
		  begin   	
		   	avg_smileys = smiley_counter(dataHash[k])
		  rescue
		    avg_smileys = 0  	
		  end	
		  begin	
		  	avg_unicode = unicode_checker(dataHash[k])
		  rescue
		    avg_unicode = 0	
		  end
		  begin	
		   	avg_story = story_examiner(dataHash[k])
		  rescue
		    avg_story = 0
		  end	
		  my_arr<<avg_ascii<<max_sim<<avg_sim<<avg_smileys<<avg_unicode<<avg_story
		  
		elsif k == "like_variations"
			#p dataHash[k]
			my_arr<<dataHash[k]["0"].to_i<<dataHash[k]["1"].to_i<<dataHash[k]["2"].to_i
		end	
	  end

	rescue => e
	ensure 
		if state == "train"
			my_arr<<var
		end	
	end    	
	if state == "train"
		#p "adding to train"
		$training[f] = my_arr
	else
		#p "adding to test"
		$test[f] = my_arr	
	end
	#p my_arr
end	


def train()
	#These two lines are only for getting malicious files out and processing only them
	File.open('mal_pages_as_ids.txt') do |alt|
	 while f = alt.gets
	 	#puts f
	 	f = f.chomp!
	#Dir.entries(Dir.pwd).select {|f| f.include? ".json"}.each do |f|
		begin
			me = File.read("#{f}.json")  
			dataHash = Hash.new
			dataHash = JSON.parse(me)
			post_processor(dataHash, f, "train", 1)			
		rescue => e
			
			p "didn't work for #{f}"	
			next
		end	
	 end
	end
	File.open('goodfiles.txt') do |alt|
	 while f = alt.gets
	 	#puts f
	 	f = f.chomp!
		begin
			me = File.read("#{f}")  
			dataHash = Hash.new
			dataHash = JSON.parse(me)
			post_processor(dataHash, f, "train", 0)			
		rescue => e
			p "didn't work for #{f}"	
			puts e
			next
		end	
	 end
	end
	
end	

def main()
	beginning = Time.now
	train()
	begin 
	  data_set = Ai4r::Data::DataSet.new(:data_items=>$training.values, :data_labels=>$labels)
	  id3 = Ai4r::Classifiers::ID3.new.build(data_set)
	rescue => e
	  puts e.backtrace
	  puts "#{e.class}, #{e.message}"
	  puts "error found"
	end  	
	
	id3.get_rules
	Dir.entries(Dir.pwd).select {|f| f.include? ".json"}.each do |f|
		begin
			#p f
			me = File.read("#{f}")  
			dataHash = Hash.new
			dataHash = JSON.parse(me)
			g = f.sub! '.json', ''
			g.to_i
			post_processor(dataHash, g)	
		rescue => e
			puts "error in #{f}"
			puts e.backtrace
			puts "#{e.class}, #{e.message}"
			next
		end	
	end
	p $training.length
	p "finished training"
	p "shouldve finsihed test too"
	fout = File.open("judgement_day.txt", "w")
	$test.each do |k, val|
	   begin
	   	p k, val
		fout.write(id3.eval(val).to_s)
		fout.write(k.to_s+"\n")
	   rescue
	    next
	   end 	
	end
	p (Time.now-beginning)
	p $test.length
	p $training.length
end	

main()