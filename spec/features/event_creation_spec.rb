require "rails_helper"

RSpec.feature 'Event creation', type: :feature do
  let(:user) { create(:user) }

  before do
    ActsAsTaggableOn::Tag.create!(name: 'Wydarzenia', is_primary: true)
  end

  scenario 'User fills new event form with proper data', js: true do
    sign_in(user)
    visit root_path

    click_link '+ Dodaj'
    click_link 'Wydarzenie'

    fill_in 'Link', with: 'https://www.facebook.com/events/1895204620756912/'
    click_button 'Pobierz tytuł'
    sleep 3

    expect(find_field('Nazwa wydarzenia').value).to eq 'Nacjonalizm?- NIE, Dziękuję! FEST VI'

    click_button 'Dodaj post'

    expect(page).to have_text('Wydarzenie utworzone pomyślnie')
  end
end
