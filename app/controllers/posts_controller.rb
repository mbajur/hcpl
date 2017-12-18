class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:saved, :new, :create, ]

  layout 'with_sidebar'

  def now
    @posts = fetch_posts.hot.last_two_weeks
  end

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
    @similar_events = PostEvent.where(city: @post.event.try(:city))
                               .where.not(id: @post.event.try(:id))
                               .includes(:post)
                               .upcoming
                               .upcoming_first
                               .limit(5)

    template = @post.media_type == 'facebook_event' ? 'events/show' : 'posts/show'

    resync_post_event_data
    render template
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
      .per(25)
      .includes(post_includes)
  end

  def posts_create_params
    params.require(:post).permit(:link, :title, :tag_list, :description)
  end

  def post_includes
    [:tags, :votes, :user, :bookmarks]
  end

  def resync_post_event_data
    return false unless @post.media_type == 'facebook_event'
    return false unless @post.event.can_be_synced?

    logger.debug 'Post has not been synced recently. Go!'

    PostScrapperJob.perform_later(@post.id)
  end

end
