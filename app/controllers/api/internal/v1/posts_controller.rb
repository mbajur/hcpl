class Api::Internal::V1::PostsController < Api::InternalController
  before_action :authenticate_user!, only: [:toggle_vote, :toggle_bookmark]

  def fetch_title
    outcome = FetchLinkData.run(params)

    if outcome.valid?
      render json: outcome.result
    else
      render json: { errors: outcome.errors }, status: :bad_request
    end
  end

  # @todo: Move that to interactor
  def toggle_vote
    post = find_post

    if current_user.voted_for?(post)
      post.votes.where(user: current_user).destroy_all
      post.user.remove_karma
      voted = false
    else
      post.votes.create!(user: current_user)
      post.user.add_karma
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
