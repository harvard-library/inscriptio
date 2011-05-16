require 'spec_helper'

describe ModeratorFlag do
  context 'has basic attributes' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
    it { should validate_presence_of(:reason) }
    
    it { should have_db_index(:post_id) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:reason) }
  end
end

describe 'a moderator_flag object' do
  fixtures :all
  before :each do
    @moderator_flag = ModeratorFlag.find(:first)
  end

end