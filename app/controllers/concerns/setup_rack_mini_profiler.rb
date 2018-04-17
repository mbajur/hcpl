module SetupRackMiniProfiler
  extend ActiveSupport::Concern

  included do
    before_action :setup_rack_miniprofiler
  end

  def setup_rack_miniprofiler
    if current_user && current_user.is_admin?
      Rack::MiniProfiler.authorize_request
    end
  end
end
