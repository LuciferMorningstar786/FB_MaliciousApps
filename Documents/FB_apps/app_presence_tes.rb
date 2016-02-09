fopen = File.open("appdata_urls.txt")
fwriter = File.open("to_be_done.txt")
while line = fopen.gets 
	line = line.chomp
	Dir.foreach(File.expand_path('~/Downloads/Final/Program/App_Installer/app_fields')).include? line
		next
	else
		fwriter.puts(line)
	end	
end		
