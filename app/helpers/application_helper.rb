module ApplicationHelper
  def build_post_path(post)
    post.path
  end

  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end

  def event_beginning_at_formatted(event)
    date = time_ago_in_words(event.beginning_at)

    if event.beginning_at > Time.zone.now.end_of_day
      "za #{date}"
    else
      "#{date} temu"
    end
  end
end
