require 'open-uri'




def get_namespace(item)
	fb = 'https://apps.facebook.com/'
	Dir.chdir('app_fields') do
		dataHash = Hash.new
		itemFile = File.open(item, "r")
		dataHash = eval(itemFile.read)
		home = dataHash[item]["namespace"]
		unless home.nil?
			return fb+home
		else return dataHash[item]["link"]
		end
	end	
end


def err_check()
end


def main()
	fallok = File.open('all_ok_page','w')
	ffail =  File.open('not_ok_page','w')
	Dir.foreach('app_fields') do |item|
		puts item
		next if item =='.' or item =='..'
        
        begin
        	my_add = get_namespace(item)
        #puts my_add
        	my_add +='/'
        	file_contents = open(my_add)
        	file_read = file_contents.read
        #puts file_read.class
        #fin = gets
        	if  ["error","Misconfigured","Sorry"].any? {|word| file_read.include?(word) }
        		puts "Error found"
        		ffail.puts(item)
        	else 
        		puts "CLEAR!"
        		fallok.puts(item)
        	end
        rescue
        	ffail.puts(item)	
        	next
        end	
	end		
end	


main()