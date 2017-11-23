class SyncPostEventDataJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    @post = Post.find(post_id)
    return false if @post.media_type != 'facebook_event'

    logger.info 'Saving facebook event data'

    attrs = {
      beginning_at: (facebook_event['start_time'] rescue nil),
      city:         (facebook_event['place']['location']['city'] rescue nil),
      synced_at:    Time.zone.now
    }

    # Move that to #find_or_initialize_by
    if @post.event.nil?
      @post.create_event! attrs
    else
      @post.event.update_attributes! attrs
    end
  end

  private

  def facebook_event
    @facebook_event ||= graph.get_connection(@post.media_guid, '')
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

end
