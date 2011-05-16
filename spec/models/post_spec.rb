require 'spec_helper'

describe Post do
  context 'has basic attributes' do
    it { should have_many(:moderator_flags) }
    it { should belong_to(:user) }
    it { should belong_to(:bulletin_board) }
    it { should validate_presence_of(:message) }
    
    it { should have_db_index(:bulletin_board_id) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:creation_time) }
  end
end

describe 'a post object' do
  fixtures :all
  before :each do
    @post = Post.find(:first)
  end

#  context do
#    it 'has moderator_flags' do
#      @post.moderator_flags.should == ModeratorFlag.find_by_post_id(@post)
#    end
#  end
  
end