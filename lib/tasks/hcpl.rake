namespace :hcpl do
  desc "Re-scrap all the posts"
  task scrap_posts: :environment do
    Post.all.each do |post|
      PostScrapperJob.perform_later(post.id)
    end
  end

  task build_cities: :environment do
    PostEvent.where.not(city: '').where.not(country_code: '').each do |pe|
      City.find_or_create_by!(name: pe.city, country_code: pe.country_code)
    end
  end
end
