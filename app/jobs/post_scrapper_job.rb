class PostScrapperJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    @post = Post.find(post_id)
    @page = MetaInspector.new(@post.link)

    save_thumb
    save_media
    save_event
  end

  private

  def save_thumb
    return false unless @page.images.best.present?

    logger.info "Thumb found, saving it: #{@page.images.best}"
    @post.update_attribute(:thumb_url, @page.images.best)
  end

  def save_media
    classifier = PageClassifier::Perform.new(@page).call
    return false unless classifier.media_type.present? && classifier.media_guid.present?

    logger.info "Media found, saving it: #{classifier.media_type} / #{classifier.media_guid}"

    @post.update_attributes(
      media_type: classifier.media_type,
      media_guid: classifier.media_guid
    )
  end

  def save_event
    return false if @post.media_type != 'facebook_event'
    SyncPostEventDataJob.perform_later(@post.id)
  end
end
