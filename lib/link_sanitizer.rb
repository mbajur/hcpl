class LinkSanitizer
  attr_accessor :url

  def initialize(url)
    @url = URI.parse url
  end

  def call
    sanitize_all
    sanitize_facebook_event

    url.to_s
  end

  private

  def sanitize_all
    link    = url.to_s
    cleared = PostRank::URI.clean(link)
    @url    = URI.parse cleared
  end

  def sanitize_facebook_event
    return unless @url.to_s =~ /facebook\.com\/events/
    @url.query = nil
  end
end
