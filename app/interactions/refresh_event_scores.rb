class RefreshEventScores < ActiveInteraction::Base
  def execute
    Rails.logger.info 'Building cities...'
    PostEvent.where.not(city: '').where.not(country_code: '').each do |pe|
      City.find_or_create_by!(name: pe.city, country_code: pe.country_code)
    end
    Rails.logger.info 'done.'

    Rails.logger.info 'Calculating cities scores...'
    City.all.each do |city|
      score = PostEvent.upcoming.where(city: city.name).average(:attendants_count)
      city.update_attribute(:score, score)
    end
    Rails.logger.info 'done.'

    Rails.logger.info 'Calculating events scores...'
    general_avg = PostEvent.upcoming.average(:attendants_count)
    PostEvent.upcoming.each do |pe|
      city = City.find_by(name: pe.city, country_code: pe.country_code)
      next unless city.present?
      city_events = city.post_events.upcoming

      base_score = city_events.count >= 2 ? city_events.average(:attendants_count) : general_avg
      score = pe.attendants_count - base_score

      pe.update_attribute(:score, score)
    end
    Rails.logger.info 'done.'
  end
end
