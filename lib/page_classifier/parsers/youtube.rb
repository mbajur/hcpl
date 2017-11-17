class PageClassifier::Parsers::Youtube < PageClassifier::Parser
  def match?(page)
    @page = page
    page.url =~ /youtube\.com/ || page.url =~ /youtu\.be/ && has_og_video?
  end

  def call
    guid = guid_from_og_video

    if guid.present?
      @media_type = :youtube
      @media_guid = guid
    end
  end

  private

  def has_og_video?
    @page.meta.key? 'og:video:url'
  end

  def guid_from_og_video
    @page.meta['og:video:url'].split('/').last
  end
end
