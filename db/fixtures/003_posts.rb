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

tags = ActsAsTaggableOn::Tag.where(is_primary: true).all.map(&:name)
user_ids = User.all.map(&:id)

time_scopes = [:minutes, :hours, :days, :months]

posts = [
  { link: 'https://youtu.be/aig-zjsuzok', title: 'Knocked Loose live at The Foundry. Great set, great energy.' },
  { link: 'https://open.spotify.com/album/6ZRiKOX9hULUptKZTLyy5a?si=r6cAwUP_RaGR2HdT6QMJng', title: '(New) Axis: “Shift”' },
  { link: 'https://lonelyboneshc.bandcamp.com/album/dominance-and-patronage', title: 'Lonely Bones - Dominance and Patronage (Colorado Hardcore)' },
  { link: 'https://www.instagram.com/p/BbSNj7WnQWM/?taken-by=dillingerescapeplan', title: "The Dillinger Escape Plan's 1st of 3 final shows in New York will feature Irony Is a Dead Scene performed in full w/ Mike Patton on vocals!!!!" },
  { link: 'https://www.youtube.com/watch?v=ahE2D-aLBRU', title: "Tears of Gaia - Burning Empires - [05:01]" },
  { link: 'https://youtu.be/gSojGEFM22c', title: "Lionheart - Cursed (yay or nay?) - [03:03]" },
  { link: 'https://www.spin.com/2017/11/nyhc-guitarist-justin-brannan-win-nyc-council-race/', title: "Justin Brannan of Most Precious Blood has been elected to a city council seat in New York." },
  { link: 'https://puuurrpleeexx.bandcamp.com/releases', title: "Meet Purple-X, new band from the Oslo underground" },
  { link: 'https://www.youtube.com/watch?v=ed9CSy1srjk', title: "No Omega - Comfort (Music Video) - [05:54]" },
]

posts.each do |post|
  Post.seed(:link, post.merge!(
    created_at: Time.zone.now - rand(100).send(time_scopes.sample),
    tag_list: tags.sample,
    user_id: user_ids.sample
  ))
end
