class SyncPostEventDataJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    @post = Post.find(post_id)
    return false if @post.media_type != 'facebook_event'

    logger.info "Facebook event data: #{facebook_event.inspect}"
    logger.info 'Saving facebook event data'

    attrs = {
      beginning_at:     (facebook_event['start_time'] rescue nil),
      country_code:     facebook_event_country_code,
      attendants_count: facebook_event_attending_count,
      synced_at:        Time.zone.now
    }

    logger.info "Data to be saved: #{attrs.inspect}"

    # Move that to #find_or_initialize_by
    if @post.event.nil?
      @post.create_event! attrs
    else
      @post.event.update_attributes! attrs
    end

    UpdateLocalizedEventCityJob.perform_later(
      @post.id,
      facebook_event_country,
      facebook_event_city
    ) if facebook_event_country.present? && facebook_event_city.present?
  end

  private

  def facebook_event
    @facebook_event ||= graph.get_connection(
      @post.media_guid,
      '?fields=id,attending_count,start_time,place{location{city,country,country_code}}'
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

  def facebook_event_city
    facebook_event['place']['location']['city'] rescue nil
  end

  def facebook_event_country
    facebook_event['place']['location']['country'] rescue nil
  end

  def facebook_event_country_code
    facebook_event['place']['location']['country_code'] rescue nil
  end

  def facebook_event_attending_count
    facebook_event['attending_count'] rescue nil
  end

end
