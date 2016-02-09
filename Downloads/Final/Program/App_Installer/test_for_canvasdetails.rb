
#nothing for canvas_fluid_width, canvas_url

count = 0
Dir.foreach('app_fields') do |item|
	if item=='.' || item=='..'
		next
	end
	Dir.chdir('app_fields') do
	    begin
	    	count+=1
	    	#puts item	 
			dataHash = Hash.new
			itemFile = File.open(item, "r")
			dataHash = eval(itemFile.read)
			home = dataHash[item]["website_url"]
			puts item," ", home unless home.nil?
		rescue Exception =>e
			puts e
		    next
		end    	
	end	
end	


puts count