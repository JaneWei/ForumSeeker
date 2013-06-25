require 'open-uri'
require 'nokogiri'
require 'timeout'
require 'rubygems'
require 'net/http'
require 'rexml/document'
require 'curb'
require 'base64'

class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
    # Sign the user in and redirect to the user's show page.
			if params[:remember_me]
				# remember user's auth_token forever
				cookies.permanent[:auth_token] = user.auth_token
			else 	
				cookies[:auth_token] = user.auth_token
			end
     	  sign_in user
        redirect_back_or user
    else
    # Create an current page error message and re-direct to new page.
      flash.now[:error] = 'Invalid email/password combination'
			render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path, :notice => "You have logged out!"
  end

	def search
	 @acctKey = "ujxABw+dytV8+udwpmxZ3nynZsb5ydqa1ijhreyocjo"#
	 @authKey = Base64.strict_encode64("#{@acctKey}:#{@acctKey}")#
	 params[:query].downcase! # get the keyword user inputed
	 @searchItem = params[:query] #keyword
	 @searchItem.strip!
	 @searchItem.gsub!("%20"," ")
	 skip_value = 0
	 @links = []
	 @result = []
	 @counter = 0
	 
	 1.times do 
	 	http = Curl.get("https://api.datamarket.azure.com/Bing/Search/Web", {:Query => "'powered by vBulletin' AND ('classified' OR 'marketplace') AND '#{@searchItem}'",  :$skip => skip_value}) do |http|
        http.headers['Authorization'] = "Basic #{@authKey}"
        #http.verbose = true
        end
     data = http.body_str
	#puts data


	 doc = REXML::Document.new(data)

	 doc.elements.each('feed/entry/content/m:properties/d:Url') do |ele|
		@links << ele.text.gsub("https","http")
		#file.write %(<"#{ele.text}"><br>)
		#counter = counter + 1
		@counter = @counter + 1
		puts "Root URL No. #{@counter}: #{@links[-1]}"
	 end
	 skip_value += 100
	end

	######
	# @links.each do |link|
	# 	url = link
 #        url_page_source = Nokogiri::HTML(open(url)) 
 #        sub_urls = url_page_source.css("a")
 #        sub_urls.each do |sub_url|
	# 		sub_url_text = sub_url.text.downcase
	# 		#if sub_url_text.index("#{keyword}") != nil
	# 		if sub_url_text.index("classified") != nil
	# 			#puts "#{sub_url_text}" + " ==> " + "#{sub_url["href"]}"
	# 			@result << sub_url
	# 		else
	# 		end     
	# 	end
	# end

    @counter = 0
	@links.each do |link|
		url = link
		@counter = @counter + 1
		begin
			status = Timeout::timeout(4){
				begin
				# open each link and get the page source
				url_page_source = Nokogiri::HTML(open(url))
			    rescue Exception => e
			    #print "error"
		        end

		        if url_page_source != nil
		        	sub_urls = url_page_source.css("a")

		        	puts "This is No. #{@counter} URL..."
                    puts "Root URL is " + "#{url}"
    
		        	sub_urls.each do |sub_url|
		        		sub_url_text = sub_url.text.downcase
		        		if (sub_url_text.index("classified") != nil) && (sub_url["href"].to_s.index("http") != nil)
		        		    if (@result != nil) && (@result.include?sub_url["href"])
		        			    
		        			else
		        				@result << sub_url["href"]
		        			    puts "classifieds of #{@searchItem.capitalize}" + " ==> " + "#{sub_url["href"]}"
		        			end
		        		else
		        		end
		        	end
		        	puts " "

		        end
		    }
		rescue Timeout::Error
		end
	end
	
   # fix the whitspace bug
	 #@searchURL.gsub!(/ /,"%20") 

	 #begin 
		#status = Timeout::timeout(6){
 	 #@searchResult = open(@searchURL,"UserAgent" => "Ruby-OpenURI").read
  	#}
	 #rescue Timeout::Error =>e
		 #redirect_to root_path, :notice => "Server in maintainence"
	 #end
	 #@links = Nokogiri::XML(@searchResult)
	 #@res = Array.new
	 #@links.xpath("//item").each do |n|
     #@res << ( n.xpath('title').inner_text)
		 #@res << ( n.xpath('link').inner_text )
   #end
	 # if @result
		# 	session[:res] = @result
		#   redirect_to current_user
	 if @result
			session[:res] = @result
		  redirect_to current_user  
	 else
	    redirect_to current_user, :notice => @searchURL , :notice => "Please Input again."
	 end
	end 
	
	private
			def modifyTitle words
				

			end

end
