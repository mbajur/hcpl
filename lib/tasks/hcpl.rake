namespace :hcpl do
  desc "Re-scrap all the posts"
  task scrap_posts: :environment do
    Post.all.each do |post|
      PostScrapperJob.perform_later(post.id)
    end
  end

  task calculate_cities_scores: :environment do
    RefreshEventScores.run!
  end
end
