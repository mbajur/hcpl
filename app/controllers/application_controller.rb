class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user, :user_signed_in?

  def index; end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    return true if user_signed_in?

    redirect_to root_path, notice: 'Najpierw musisz się zalogować'
    return false
  end
end
