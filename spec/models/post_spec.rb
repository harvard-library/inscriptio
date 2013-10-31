require 'spec_helper'

describe Post do
  context 'has basic attributes' do
    it { should have_many(:moderator_flags) }
    it { should belong_to(:user) }
    it { should belong_to(:bulletin_board) }
    it { should validate_presence_of(:message) }

    it { should have_db_index(:bulletin_board_id) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:created_at) }
  end
end

describe 'a post object' do
  fixtures :all
  before :each do
    @post = FactoryGirl.build(:post)
  end

  context do
    pending
  end

end
