module SessionsHelper

  def sign_in(user)
		# Maybe has a duplication, anyway, go on...
    cookies.permanent[:auth_token] = user.auth_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def admin?
		 current_user.admin?
  end 

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token])if cookies[:auth_token]
  end

  def current_user?(user)
    user == current_user
  end
  
  def sign_out
    self.current_user = nil
		unless params[:remember_me]
      cookies.delete(:auth_token)
		end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end


end
