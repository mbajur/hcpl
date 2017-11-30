class FetchLinkData < ActiveInteraction::Base
  string :link, default: nil

  validates :link, presence: true, url: { message: 'wydaje się być niepoprawny' }

  def execute
    {
      title:      data[:page].best_title,
      media_type: data[:classifier].media_type,
      media_guid: data[:classifier].media_guid
    }
  end

  private

  def cache_key
    md5 = Digest::MD5.new.hexdigest inputs[:link]
    ['fetch_link_data', md5].join('/')
  end

  def data
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      page       = MetaInspector.new(inputs[:link])
      classifier = PageClassifier::Perform.new(page).call

      { page: page, classifier: classifier }
    end
  end
end
