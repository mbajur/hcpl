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

  task cast_votes: :environment do
    puts 'Enter post token: '
    token = STDIN.gets.chomp
    post = Post.find_by!(token: token)

    puts 'Enter voter ID: '
    user_id = STDIN.gets.chomp || ENV['SYSTEM_USER_ID']
    user = User.find(user_id)

    puts 'Enter votes count: '
    votes = STDIN.gets.chomp

    votes.to_i.times { post.votes.create! user: user }

    puts 'Done!'
  end
end
