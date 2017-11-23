class EventsController < ApplicationController

  layout 'with_sidebar'

  def index
    @posts = fetch_posts.upcoming_events.page(params[:page]).per(50)
    @posts_months = @posts.group_by { |p| p.event.beginning_at.beginning_of_month }
    @cities = cities_stats_for(PostEvent.upcoming)
  end

  def past
    @posts = fetch_posts.past_events.page(params[:page]).per(50)
    @posts_months = @posts.group_by { |p| p.event.beginning_at.beginning_of_month }
    @cities = cities_stats_for(PostEvent.past)
  end

  private

  def fetch_posts
    res = Post
            .includes(post_includes)
            .tagged_with('Wydarzenia')

    res = res.search(params[:q]) if params[:q].present?

    res
  end

  def post_includes
    [:tags, :votes, :user, :bookmarks, :event]
  end

  def cities_stats_for(col)
    res = []
    cities = col.group(:city).count

    cities.keys.each do |k|
      res << {
        name: k,
        count: cities[k]
      }
    end

    res
      .sort! { |a,b| b[:count] <=> a[:count] }
      .reject! { |c| c[:name].nil? }

    sum = res.sum { |r| r[:count] }
    res.each { |c| c[:percent] = c[:count].to_f / sum.to_f * 100.0 }

    res
  end

end
