class UsersController < ApplicationController

  layout 'with_sidebar'

  def show
    authenticate_user!

    @user = User.find_by!(username: params[:username])
    @posts = fetch_posts(@user.posts).recent_first
  end

  private

  def fetch_posts(col)
    col
      .page(params[:page])
      .per(25)
      .includes(post_includes)
  end

  def post_includes
    [:tags, :votes, :user, :bookmarks]
  end

end
