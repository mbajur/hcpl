class PageClassifier::Parsers::BandcampAlbum < PageClassifier::Parser

  def match?(page)
    @page = page
    page.url =~ /bandcamp\.com/ && has_og_video?
  end

  def call
    guid = album_id_from_og_video

    if guid.present?
      @media_type = :bandcamp_album
      @media_guid = guid
    end
  end

  private

  def has_og_video?
    @page.meta.key? 'og:video'
  end

  def album_id_from_og_video
    @page.meta['og:video'][/album=\d+/][/\d+/]
  end

end
