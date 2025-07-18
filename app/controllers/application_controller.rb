class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:alert] = "Must be logged in to perform that action"
            redirect_to login_path
        end
    end

    def require_same_user
        if current_user != @article.user && !current_user.admin?
            flash[:alert] = "Can only edit or delete your own articles"
            redirect_to @article
        end
    end

    def require_admin
        if !(logged_in? && current_user.admin?)
            flash[:alert] = "Admins only can perform that action"
            redirect_to root_path
        end
    end

end
