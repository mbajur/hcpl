class UpdateLocalizedEventCityJob < ApplicationJob
  queue_as :default

  def perform(post_id, country, city)
    @post       = Post.find(post_id)
    @post_event = @post.event
    @city       = city
    @country    = country

    return false unless @post_event.present?

    logger.info "Localizing #{city} city"

    if geo_results.present?
      logger.info "Setting city as #{geo_results.address.city}"
      @post_event.update_attribute(:city, geo_results.address.city)
    end
  end

  private

  attr_reader :city, :country

  def cache_key
    city_md5    = Digest::MD5.new.hexdigest(city)
    country_md5 = Digest::MD5.new.hexdigest(country)

    ['nominatim', country_md5, city_md5].join('/')
  end

  def geo_results
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      Nominatim
        .search
        .city(city)
        .country(country)
        .limit(1)
        .address_details(true)
        .first
    end
  end

end
