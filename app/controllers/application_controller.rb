class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user, :user_signed_in?

  before_action :stub_user_id
  before_action :setup_rack_miniprofiler

  rescue_from Posts::Create::LinkNotUniqueError, with: :handle_posts_create_link_not_unique_error

  def index; end

  private

  # Based on:
  # http://library.edgecase.com/oath-and-capybara
  def stub_user_id
    return true unless Rails.env.test?
    return true unless cookies[:stub_user_id].present?

    user = User.find(cookies[:stub_user_id])
    UserSession.new(user).save!
  end

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

  def handle_posts_create_link_not_unique_error(e)
    existing = e.existing_post
    redirect_to existing.path, notice: 'Link był już dodany wcześniej. Zostałeś do niego przekierowany.'
    return false
  end
end
