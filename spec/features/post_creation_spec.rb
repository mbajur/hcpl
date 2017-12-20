require "rails_helper"

RSpec.feature 'Post creation', type: :feature do
  let(:user) { create(:user) }

  before do
    ActsAsTaggableOn::Tag.create!(name: 'Wydarzenia', is_primary: true)
  end

  scenario 'User fills new post form with proper data', js: true do
    sign_in(user)
    visit root_path

    click_link '+ Dodaj'
    click_link 'Link lub tekst'

    fill_in 'Link', with: 'http://forum.hard-core.pl'
    click_button 'Pobierz tytuł'
    sleep 3

    expect(find_field('Tytuł posta').value).to eq 'forum.hard-core.pl'

    find(:css, 'input.multiselect__input').set('Wydarzenia')
    find(:css, '.multiselect__option--highlight').click()

    click_button 'Dodaj post'

    expect(page).to have_text('Post utworzony pomyślnie')
  end
end
