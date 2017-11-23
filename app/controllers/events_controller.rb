class EventsController < ApplicationController

  layout 'with_sidebar'

  def index
    @events = fetch_events.upcoming.upcoming_first

    @events_months = @events.group_by { |e| e.beginning_at.beginning_of_month }
    @cities = cities_stats_for(PostEvent.upcoming)
  end

  def past
    @events = fetch_events.past
    @events_months = @events.group_by { |e| e.beginning_at.beginning_of_month }
    @cities = cities_stats_for(PostEvent.past)
  end

  private

  def fetch_events
    res = PostEvent.includes(:post, post: [:votes, :user, :bookmarks])
                   .page(params[:page])

    res = res.search(params[:q]) if params[:q].present?

    res
  end

  def cities_stats_for(col)
    res = []
    cities = col.group(:city).count

    cities.keys.each do |k|
      res << { name: k, count: cities[k] }
    end

    res.sort! { |a,b| b[:count] <=> a[:count] }
       .reject! { |c| c[:name].nil? }

    sum = res.sum { |r| r[:count] }
    res.each { |c| c[:percent] = c[:count].to_f / sum.to_f * 100.0 }

    res
  end

end
