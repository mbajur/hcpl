require "rails_helper"

RSpec.feature 'Post creation', type: :feature do
  let(:user) { create(:user) }
  let(:link) { 'http://forum.hard-core.pl' }
  let(:title) { 'forum hard|core.pl' }

  before do
    # Clear rails cache to prevent link scrapper from caching the result
    Rails.cache.clear

    ActsAsTaggableOn::Tag.create!(name: 'Wydarzenia', is_primary: true)

    stub_request(:get, link)
      .with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'identity', 'User-Agent'=>'MetaInspector/5.4.1 (+https://github.com/jaimeiniesta/metainspector)'})
      .to_return(status: 200, body: "<html><head><title>#{title}</title></head></html>", headers: {})
  end

  scenario 'User fills new post form with proper data', js: true do
    sign_in(user)
    visit root_path

    click_link '+ Dodaj'
    click_link 'Link lub tekst'

    fill_in 'Link', with: link
    click_button 'Pobierz tytuł'
    sleep 3

    expect(find_field('Tytuł posta').value).to eq title

    find(:css, 'input.multiselect__input').set('Wydarzenia')
    find(:css, '.multiselect__option--highlight').click()

    click_button 'Dodaj post'

    # Display notice
    expect(page).to have_text('Post utworzony pomyślnie')

    # Post should be voted up
    expect(find(:css, '.posts-item-vote').text).to have_text(1)
  end
end
