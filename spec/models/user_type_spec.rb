require 'spec_helper'

describe UserType do
  context 'has basic attributes' do
    it { should have_many(:users) }
    it { should have_and_belong_to_many(:reservable_asset_types) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should have_db_index(:name) }
  end
end

describe 'a user_type object' do
  before :each do
    @user_type = FactoryGirl.build(:user_type, :name => 'student')
  end

  context do
    it 'talks about itself' do
      expect(@user_type.to_s).to eq('student')
      expect(@user_type.to_s).to eq(@user_type.name)
    end
  end

  context do
    it 'has users' do
      @user_type.users.each do |u| expect(u).to be_a(User) end
    end

    it 'has reservable_asset_types' do
      @user_type.reservable_asset_types.each do |rat| expect(rat).to be_a(ReservableAssetType) end
      @user_type.reservable_asset_types.should == @user_type.reservable_asset_types
    end
  end

end
