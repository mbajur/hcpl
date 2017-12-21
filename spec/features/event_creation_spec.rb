require "rails_helper"

RSpec.feature 'Event creation', type: :feature do
  let(:user) { create(:user) }
  let(:link) { 'https://www.facebook.com/events/1895204620756912' }
  let(:title) { 'Nazwa koncertu' }

  before do
    # Clear rails cache to prevent link scrapper from caching the result
    Rails.cache.clear

    ActsAsTaggableOn::Tag.create!(name: 'Wydarzenia', is_primary: true)

    stub_request(:get, link)
      .to_return(status: 200, body: "<html><head><title>#{title}</title></head></html>", headers: {})

    stub_request(:post, "https://graph.facebook.com/oauth/access_token")
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, /graph.facebook.com\/1895204620756912/)
      .to_return(status: 200, body: '', headers: {})
  end

  scenario 'User fills new event form with proper data', js: true do
    sign_in(user)
    visit root_path

    click_link '+ Dodaj'
    click_link 'Wydarzenie'

    fill_in 'Link', with: link
    click_button 'Pobierz tytuł'
    sleep 3

    expect(find_field('Nazwa wydarzenia').value).to eq title

    click_button 'Dodaj post'

    expect(page).to have_text('Wydarzenie utworzone pomyślnie')
  end
end
