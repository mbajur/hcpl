class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user, :user_signed_in?

  before_action :setup_rack_miniprofiler

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

  def setup_rack_miniprofiler
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  # If post with given link exists, redirect user to it with proper notice
  def redirect_to_post_if_exists
    return true unless posts_create_params[:link].present?

    existing_post = Post.find_by(link: posts_create_params[:link])
    return true unless existing_post.present?

    redirect_to existing_post.path, notice: 'Link był już dodany wcześniej. Zostałeś do niego przekierowany.'
    return false
  end
end
