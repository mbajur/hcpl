ActsAsTaggableOn::Tag.class_eval do

  before_save :set_slug

  private

  def set_slug
    self.slug ||= name.to_slug.normalize.to_s
  end

end
