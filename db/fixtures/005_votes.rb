user_ids = User.all.map(&:id)

Post.all.each do |post|
  user_ids.each do |user_id|
    next unless [false, false, false, true].sample

    Vote.seed(:user_id, :voteable_id, :voteable_type) do |v|
      v.voteable = post
      v.user_id  = user_id
    end
  end
end
