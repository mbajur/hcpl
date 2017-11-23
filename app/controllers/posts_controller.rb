class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:saved, :new, :create, ]

  layout 'with_sidebar'

  def week
    @posts = fetch_posts.popular.this_week
  end

  def month
    @posts = fetch_posts.popular.this_month
  end

  def year
    @posts = fetch_posts.popular.this_year
  end

  def recent
    @posts = fetch_posts.recent_first
  end

  def saved
    @bookmarks = current_user.bookmarks
                             .includes(bookmarkable: post_includes)
                             .where(bookmarkable_type: 'Post')
                             .page(params[:page])
                             .per(50)
                             .recent_first
  end

  def show
    @post = Post.find_by!(token: params[:token])
    @comment = Comment.new(post: @post)

    resync_post_event_data
  end

  def search
    @posts = fetch_posts.search(params[:q])
  end

  def new
    @post = Posts::Create.new(
      link:  params[:link],
      title: params[:title],
      tag_list: params[:tag_list]
    )
  end

  def create
    redirect_to_post_if_exists

    @post = Posts::Create.run(
      posts_create_params.merge!(user: current_user)
    )

    if @post.valid?
      redirect_to @post.result.path, notice: 'Post utworzony pomyślnie!'
    else
      render :new
    end
  end

  private

  def fetch_posts
    Post
      .page(params[:page])
      .per(50)
      .includes(post_includes)
  end

  def posts_create_params
    params.require(:post).permit(:link, :title, :tag_list, :description)
  end

  # If post with given link exists, redirect user to it with proper notice
  def redirect_to_post_if_exists
    return unless posts_create_params[:link].present?

    existing_post = Post.find_by(link: posts_create_params[:link])
    return unless existing_post.present?

    redirect_to existing_post.path
    return
  end

  def post_includes
    [:tags, :votes, :user, :bookmarks]
  end

  def resync_post_event_data
    return false unless @post.media_type == 'facebook_event'
    return false unless @post.event.can_be_synced?

    logger.debug 'Post has not been synced recently. Go!'

    SyncPostEventDataJob.perform_later(@post.id)
  end

end
