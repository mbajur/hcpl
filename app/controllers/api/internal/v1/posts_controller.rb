class Api::Internal::V1::PostsController < Api::InternalController

  def fetch_title
    page       = MetaInspector.new(params[:link])
    classifier = PageClassifier::Perform.new(page).call

    render json: { title: page.best_title, media_type: classifier.media_type, media_guid: classifier.media_guid }
  end

  def toggle_vote
    post = find_post

    if current_user.voted_for?(post)
      post.votes.where(user: current_user).destroy_all
      voted = false
    else
      post.votes.create!(user: current_user)
      voted = true
    end

    votes_count = post.reload.votes_count

    render json: { voted: voted, votes_count: votes_count }
  end

  def toggle_bookmark
    post = find_post

    if current_user.bookmarked?(post)
      post.bookmarks.where(user: current_user).destroy_all
      bookmarked = false
    else
      post.bookmarks.create!(user: current_user)
      bookmarked = true
    end

    render json: { bookmarked: bookmarked }
  end

  private

  def find_post
    Post.find_by!(token: params[:token])
  end

end
