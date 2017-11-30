class FetchLinkData < ActiveInteraction::Base
  string :link, default: nil

  validates :link, presence: true, url: { message: 'wydaje się być niepoprawny' }

  def execute
    page       = MetaInspector.new(inputs[:link])
    classifier = PageClassifier::Perform.new(page).call

    {
      title:      page.best_title,
      media_type: classifier.media_type,
      media_guid: classifier.media_guid
    }
  end
end
