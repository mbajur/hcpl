module PostVotingHelper
  def click_vote_post_btn(post)
    find(:css, "[data-post-token='#{post.token}'] .btn-post-vote").click()
  end

  def expect_post_to_have_n_votes(post, n)
    expect(
      find(:css, "[data-post-token='#{post.token}'] .posts-item-vote").text
    ).to have_text(n)
  end
end
