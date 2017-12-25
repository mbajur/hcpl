class ApplicationController < ActionController::Base
  include Auth

  protect_from_forgery with: :exception

  before_action :setup_rack_miniprofiler

  rescue_from Posts::Create::LinkNotUniqueError, with: :handle_posts_create_link_not_unique_error

  def index; end

  private

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
