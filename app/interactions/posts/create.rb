class Posts::Create < ActiveInteraction::Base
  string :link, default: nil
  string :title, default: nil
  string :description, default: nil
  string :tag_list
  object :user

  validates :link, allow_blank: true, url: { message: 'wydaje się być niepoprawny' }
  validates :description, allow_blank: true, length: { minimum: 10 }
  validates :title, allow_blank: true, length: { minimum: 10 }
  validates :title, presence: true
  validates :user, presence: true
  validates :tag_list, presence: true

  validate :link_or_description_present

  set_callback :validate, :before, :clear_link

  def to_model
    Post.new
  end

  def execute
    post = Post.new(inputs)

    # Remove junk from links
    post.link = clear_link(post.link)

    if post.save
      cast_vote(post)
      PostScrapperJob.perform_later(post.id)
      user.add_karma
    else
      errors.merge!(post.errors)
    end

    post
  end

  private

  def cast_vote(post)
    post.votes.create(user_id: inputs[:user].id)
  end

  def link_or_description_present
    return true if !(link.blank? && description.blank?)

    errors.add(:base, 'Post musi posiadać link lub tekst')
  end

  def clear_link
    self.link = PostRank::URI.clean(link) if link.present?
  end
end
