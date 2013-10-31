require 'spec_helper'

describe User do
  context 'has basic attributes' do
    it { should have_many(:moderator_flags) }
    it { should have_many(:posts) }
    it { should have_many(:reservable_assets) }
    it { should have_many(:reservations) }
    it { should belong_to(:user_type) }
    it { should validate_presence_of(:email) }
    
    it { should have_db_index(:email) }
    it { should have_db_index(:reset_password_token) }
  end
end

describe 'a user object' do
  before :each do
    @user = FactoryGirl.build(:user)
  end

  context do
    it 'talks about itself' do
      pending 'Dave needs to read to_s method'
    end
  end
  
end