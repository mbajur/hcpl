class City < ApplicationRecord
  def post_events
    PostEvent.where(city: name, country_code: country_code)
  end
end
