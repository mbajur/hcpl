require "rails_helper"

RSpec.feature 'Karma points', type: :feature do
  let(:op) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let!(:post) { create(:post, user: op) }

  scenario 'User adds a post and votes by other users adds karma to OP', js: true do
    sign_in(op)
    visit root_path

    # Original poster
    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 1)
    sleep 2

    # First user
    sign_in(user1)
    visit root_path

    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 2)

    # Second user
    sign_in(user2)
    visit root_path

    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 3)

    # Third user
    sign_in(user3)
    visit root_path

    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 4)

    # Visit OP profile and check his karma
    within("[data-post-token='#{post.token}']") do
      click_link op.username
    end

    expect(page).to have_text 'Karma: 4'
  end
end
