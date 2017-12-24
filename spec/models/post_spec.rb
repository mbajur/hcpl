require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#hot' do
    subject { Post.hot.map(&:title) }

    describe 'hottness based on votes count and creation date' do
      before do
        @post1 = create(:post, title: '#2', created_at: DateTime.parse('15 Dec 2017 09:51:02'), votes_count: 1)
        @post2 = create(:post, title: '#3', created_at: DateTime.parse('15 Dec 2017 09:48:52'), votes_count: 1)
        @post3 = create(:post, title: '#1', created_at: DateTime.parse('15 Dec 2017 07:33:02'), votes_count: 3)
      end

      it 'orders posts properly' do
        expect(subject).to eq [@post3.title, @post1.title, @post2.title]
      end
    end

    describe 'hottness based on tags hottness_mod' do
      before do
        create(:tag, name: 'plhc', hottness_mod: 2)
        create(:tag, name: 'Wydarzenia', hottness_mod: -2)

        @post1 = create(:post, title: '#2', created_at: DateTime.parse('15 Dec 2017 10:00:00'), votes_count: 1, tag_list: 'Wydarzenia')
        @post2 = create(:post, title: '#1', created_at: DateTime.parse('15 Dec 2017 09:50:00'), votes_count: 1, tag_list: 'plhc')
      end

      it { expect(subject).to eq [@post2.title, @post1.title] }
    end
  end
end
