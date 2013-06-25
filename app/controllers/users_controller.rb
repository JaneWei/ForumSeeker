require 'open-uri'
require 'nokogiri'
class UsersController < ApplicationController
 
  include SessionsHelper 
 
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end  


  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      # Handle a successful save.
      flash[:success] = "Welcome to the Forum Deal Seeker!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id]) #we don't need this for filter.
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end 
    
  #def search
    #params[:query].downcase! 
    #@searchItem = params[:query]
    #@buzzilaAPI = "http://api.buzzilla.com/buzzilla/query?token=de4bd5c9-cbe3-437d-b870-751141cdd803&dataType=xml&pageNum=1&sortBy=relevance&query=forum:"
   #@searchURL = @buzzilaAPI + @searchItem
    #@searchResult = open(@searchURL,"UserAgent" => "Ruby-OpenURI").read
    #@links = Nokogiri::XML(@searchResult)
		#@res = Array.new
		#@links.xpath("//item").each do |n|
			#@res << ( n.xpath("link").inner_text) 
		#end
		#if @res
			#session[:res] = @res
    	#redirect_to current_user 
    #else
		  #redirect_to current_user, :notice => @searchURL , :notice => "Please Input again." 
		#end
 	#end    


  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end
  
     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
