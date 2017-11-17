class Posts::Create < ActiveInteraction::Base
  string :link, default: nil
  string :title, default: nil
  string :description, default: nil
  string :tag_list
  object :user

  validates :link, presence: true, if: proc { |p| p.description.blank? }
  validates :description, presence: true, length: { minimum: 10 }, if: proc { |p| p.link.blank? }
  validates :title, presence: true, length: { minimum: 10 }
  validates :user, presence: true
  validates :tag_list, presence: true

  def to_model
    Post.new
  end

  def execute
    post = Post.new(inputs)

    if post.save
      cast_vote(post)
      PostScrapperJob.perform_later(post.id)
    else
      errors.merge!(post.errors)
    end

    post
  end

  private

  def cast_vote(post)
    post.votes.create(user_id: inputs[:user].id)
  end
end
