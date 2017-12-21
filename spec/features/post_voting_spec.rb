require "rails_helper"

RSpec.feature 'Voting on posts', type: :feature do
  let(:user) { create(:user) }
  let!(:post) { create(:post, votes_count: 1) }

  before do
    create_list(:post, 3, votes_count: 1)
    sign_in(user)
  end

  scenario 'User votes on a post on homepage', js: true do
    visit root_path

    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 2)

    click_vote_post_btn(post)
    expect_post_to_have_n_votes(post, 1)
  end
end
