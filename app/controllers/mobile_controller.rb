class MobileController < ActionController::Base
  include Auth
  include SetupRackMiniProfiler

  protect_from_forgery with: :exception

  before_action :setup_rack_miniprofiler

  layout 'mobile'

  def index; end
end
