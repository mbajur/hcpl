module Auth
  extend ActiveSupport::Concern

  included do
    helper_method :current_user_session, :current_user, :user_signed_in?
    before_action :stub_user_id
  end

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
end
