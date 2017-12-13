require 'rails_helper'

RSpec.describe LinkSanitizer, type: :lib do
  let(:service) { described_class.new(link) }

  subject { service.call }

  context 'when link contains tracking params' do
    let(:link) { 'https://example.com/?utm_source=xxx' }

    it { is_expected.to eq 'https://example.com/' }
  end

  context 'when link is a facebook event' do
    context 'when link contains trash facebook params' do
      let(:link) { 'https://www.facebook.com/events/1927521197460130/?acontext=%7B%22ref%22%3A%223%22%2C%22ref_newsfeed_story_type%22%3A%22regular%22%2C%22feed_story_type%22%3A%22263%22%2C%22action_history%22%3A%22null%22%7D' }

      it { is_expected.to eq 'https://www.facebook.com/events/1927521197460130' }
    end
  end
end
