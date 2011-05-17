require 'spec_helper'

describe ReservableAssetType do
  context 'has basic attributes' do
    it { should belong_to(:library) }
    it { should have_many(:reservable_assets) }
#    it { should have_many(:reservation_expiration_notices) }
    it { should have_and_belong_to_many(:user_types) }
    it { should validate_presence_of(:library_id) }
    it { should validate_presence_of(:name) }

    it { should have_db_index(:library_id) }
    it { should have_db_index(:name) }
  end
end

describe 'A reservable_asset_type object' do
  fixtures :all
  before :each do
    @reservable_asset_type = ReservableAssetType.find_by_name('carrel')
  end
  context do
    it "talks about itself" do
      @reservable_asset_type.to_s.should == 'carrel'
      @reservable_asset_type.to_s.should_not == 'foobar'
    end
    
    it 'has reservable_assets' do
      @reservable_asset_type.reservable_assets.should == @reservable_asset_type.reservable_assets
    end
    
    it 'has user_types' do
      @reservable_asset_type.user_types.should == @reservable_asset_type.user_types
    end
    
    it "has a photo" do
      @reservable_asset_type.photo = File.open('public/images/rails.png')
      assert @reservable_asset_type.save
      assert ! @reservable_asset_type.photo.blank?
      @reservable_asset_type.photo.size.should > 0
    end

  end
end