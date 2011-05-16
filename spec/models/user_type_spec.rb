require 'spec_helper'

describe UserType do
  context 'has basic attributes' do
#    it { should have_many(:users) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should have_db_index(:name) }
  end
end

describe 'a user_type object' do
  fixtures :all
  before :each do
    @user_type = UserType.find_by_name('student')
  end

  context do
    it 'talks about itself' do
      @user_type.to_s.should == 'student'
      @user_type.to_s.should_not == 'stu'
    end
  end

  context do
    it 'has users' do
      @user_type.users.should == @user_type.users
    end
  end
  
end