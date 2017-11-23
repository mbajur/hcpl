class EventsController < ApplicationController

  layout 'with_sidebar'

  def index
    @posts = fetch_posts.upcoming_events.page(params[:page]).per(50)
    @posts_months = @posts.group_by { |p| p.event.beginning_at.beginning_of_month }
  end

  def past
    @posts = fetch_posts.past_events.page(params[:page]).per(50)
    @posts_months = @posts.group_by { |p| p.event.beginning_at.beginning_of_month }
  end

  private

  def fetch_posts
    Post
      .page(params[:page])
      .includes(post_includes)
      .tagged_with('Wydarzenia')
  end

  def post_includes
    [:tags, :votes, :user, :bookmarks, :event]
  end

end
