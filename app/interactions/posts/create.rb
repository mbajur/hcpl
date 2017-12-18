class Posts::Create < ActiveInteraction::Base

  class LinkNotUniqueError < ArgumentError
    attr_reader :existing_post

    def initialize(msg, existing_post)
      @existing_post = existing_post
      super(msg)
    end
  end

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

  set_callback :validate, :before, :sanitize_link

  def to_model
    Post.new
  end

  def execute
    post = Post.new(inputs)

    check_link_uniqueness!

    if post.save
      after_create(post)
    else
      errors.merge!(post.errors)
    end

    post
  end

  private

  def check_link_uniqueness!
    existing = Post.find_by(link: link)
    raise LinkNotUniqueError.new(nil, existing) if existing.present?
  end

  def cast_vote(post)
    post.votes.create(user_id: inputs[:user].id)
  end

  def link_or_description_present
    return true if !(link.blank? && description.blank?)

    errors.add(:base, 'Post musi posiadać link lub tekst')
  end

  def sanitize_link
    self.link = LinkSanitizer.new(link).call if link.present?
  end

  def after_create(post)
    cast_vote(post)
    user.add_karma

    PostScrapperJob.perform_later(post.id)
  end
end
