require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#hot' do
    subject { Post.hot.map(&:title) }

    before do
      @post1 = create(:post, title: '#2', created_at: DateTime.parse('15 Dec 2017 09:51:02'), votes_count: 1)
      @post2 = create(:post, title: '#3', created_at: DateTime.parse('15 Dec 2017 09:48:52'), votes_count: 1)
      @post3 = create(:post, title: '#1', created_at: DateTime.parse('15 Dec 2017 07:33:02'), votes_count: 3)
    end

    it 'orders posts properly' do
      expect(subject).to eq [@post3.title, @post1.title, @post2.title]
    end
  end
end
