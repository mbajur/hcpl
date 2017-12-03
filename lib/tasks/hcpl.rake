namespace :hcpl do
  desc "Re-scrap all the posts"
  task scrap_posts: :environment do
    Post.all.each do |post|
      PostScrapperJob.perform_later(post.id)
    end
  end

  task calculate_cities_scores: :environment do
    puts 'Building cities...'
    PostEvent.where.not(city: '').where.not(country_code: '').each do |pe|
      City.find_or_create_by!(name: pe.city, country_code: pe.country_code)
    end
    puts 'done.'

    puts 'Calculating cities scores...'
    City.all.each do |city|
      attendants = PostEvent.upcoming.where(city: city.name).map(&:attendants_count)

      sorted = attendants.sort
      len = sorted.length
      next if len == 0

      score = (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
      city.update_attribute(:score, score)
    end
    puts 'done.'
  end
end
