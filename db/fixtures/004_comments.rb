titles = [
  "The Dillinger Escape Plan's 1st of 3 final shows in New York will feature Irony Is a Dead Scene performed in full w/ Mike Patton on vocals!!!!",
  "Tears of Gaia - Burning Empires",
  "Lonely Bones - Dominance and Patronage (Colorado Hardcore)",
  "BOYS ONLY WANT ONE THING(CREDIT TO SHINIGAMA PAGE ON FB)",
  "Lionheart - Cursed (yay or nay?)",
  "FFO: Stranger Things // The Demogorgon apparently has a playlist full of Death Metal, Deathcore, Black Metal, etc. such as TBDM, Deafheaven, Slayer, Skeletal, Carcass, Entombed, and more.",
  "Sect - Day For Night",
  "Incase yall missed it...",
  "Not sure of these guys fit here, but I really think they should be heard.",
  "Downpresser - Benefice Of The Doubt",
  "Justin Brannan of Most Precious Blood has been elected to a city council seat in New York.",
  "GUILT RITUAL - Lapse in Sanity. Western Mass HC ffo: Unbroken, 108, Converge, Hope Con"
]

time_scopes = [:minutes, :hours, :days, :months]

user_ids = User.all.map(&:id)

Post.all.each do |post|
  if [false, false, false, true].sample
    5.times do
      next unless [false, false, false, true].sample

      Comment.seed do |c|
        c.post = post
        c.body = titles.sample
        c.created_at = Time.zone.now - rand(100).send(time_scopes.sample)
        c.user_id = user_ids.sample
      end
    end
  end
end
