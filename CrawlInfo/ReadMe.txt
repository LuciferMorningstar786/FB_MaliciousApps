intructions about CrwalAppInfo.rb

Please modify the following lines accordingly before running this program:
1. line 3: access token (The normal user access token will expire in two hours, so it needs to be changed in time)

2. line 6: filename = "./out3/"+appid+".json";
Change the output directory and output filename.  In the above example, the output file will be named as appid.json , and be saved in folder "out3"


3. line 119: File.open('./newapps/urllist_appdata_3.txt', 'r') do |f1|
Change the input file name and directory to the applist you want to crawl, and make sure it only content id per line.  Or you can use gsub comment to replace some useless prefix, as shown in line 121.


