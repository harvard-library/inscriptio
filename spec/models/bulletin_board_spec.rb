require 'spec_helper'

describe BulletinBoard do
  context 'has basic attributes' do
    it { should have_many(:posts) }
#    it { should have_many(:users) }
    it { should belong_to(:reservable_asset) }
    it { should have_db_index(:reservable_asset_id) }
  end
end

describe 'a bulletin_board object' do
  fixtures :all
  before :each do
    @bulletin_board = BulletinBoard.find(:first)
  end

#  context do
#    it 'has posts' do
#      @bulletin_board.posts.should == Post.find_by_bulletin_board_id(@bulletin_board)
#    end
#  end
  
#  context do
#    it 'has users' do
#      @bulletin_board.users.should == [User.find_by_id(1),Post.find_by_id(2),Post.find_by_id(3)]
#    end
#  end
  
end