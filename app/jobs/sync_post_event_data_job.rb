class SyncPostEventDataJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    @post = Post.find(post_id)
    return false if @post.media_type != 'facebook_event'

    attrs = {
      beginning_at:     (facebook_event['start_time'] rescue nil),
      attendants_count: facebook_event_attending_count,
      synced_at:        Time.zone.now
    }

    if facebook_event_lat.present? && facebook_event_lon.present?
      attrs[:city]         = geo_results.address.city
      attrs[:country_code] = geo_results.address.country_code.try(:upcase)
    end

    logger.debug 'Saving facebook event data:'
    logger.debug attrs.inspect

    # Move that to #find_or_initialize_by
    if @post.event.nil?
      @post.create_event! attrs
    else
      @post.event.update_attributes! attrs
    end
  end

  private

  def facebook_event
    @facebook_event ||= graph.get_connection(
      @post.media_guid,
      '?fields=id,attending_count,start_time,place{name,location{latitude,longitude}},cover'
    )
  end

  def graph
    logger.debug 'Initializing graph client'

    token = Rails.cache.fetch('facebook_token', expires_in: 40.minutes) do
      oauth = Koala::Facebook::OAuth.new(
        ENV['FACEBOOK_APP_ID'],
        ENV['FACEBOOK_APP_SECRET'],
        'http://localhost:3000/admin/fbwall'
      )
      oauth.get_app_access_token
    end

    Koala::Facebook::API.new(token)
  end

  def facebook_event_lat
    facebook_event['place']['location']['latitude'].to_s rescue nil
  end

  def facebook_event_lon
    facebook_event['place']['location']['longitude'].to_s rescue nil
  end

  def facebook_event_attending_count
    facebook_event['attending_count'] rescue nil
  end

  def nominatim_cache_key
    latitude_md5  = Digest::MD5.new.hexdigest(facebook_event_lat)
    longitude_md5 = Digest::MD5.new.hexdigest(facebook_event_lon)

    ['nominatim', latitude_md5, longitude_md5].join('/')
  end

  def geo_results
    Rails.cache.fetch(nominatim_cache_key, expires_in: 10.minutes) do
      Nominatim::Reverse
        .new
        .lat(facebook_event_lat)
        .lon(facebook_event_lon)
        .fetch
    end
  end

end
