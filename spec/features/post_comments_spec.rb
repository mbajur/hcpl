require "rails_helper"

RSpec.feature 'Post comments', type: :feature do
  let!(:post) { create(:post) }
  let(:user) { create(:user) }

  scenario 'User adds comment to a post', js: true do
    sign_in(user)
    visit root_path

    within("[data-post-token='#{post.token}']") do
      click_link '0 komentarze'
    end

    expect(current_path).to eq post.path

    within '#new_comment' do
      fill_in 'comment_body', with: 'Comment body'
      click_button 'Utwórz Comment'
    end

    expect(page).to have_content 'Komentarz dodany pomyślnie!'
    expect(page).to have_content '1 komentarzy'
    expect(page).to have_content 'Comment body'
  end
end
