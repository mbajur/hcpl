class PageClassifier::Parsers::FacebookEvent < PageClassifier::Parser
  def match?(page)
    @page = page
    page.url =~ /facebook\.com\/events\/\d+/
  end

  def call
    if guid_from_url.present?
      @media_type = :facebook_event
      @media_guid = guid_from_url
    end
  end

  private

  def guid_from_url
    uri = URI.parse(@page.url)
    uri.path.split('/').last
  end
end
