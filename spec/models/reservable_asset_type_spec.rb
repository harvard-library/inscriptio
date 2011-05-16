require 'spec_helper'

describe ReservableAssetType do
  context 'has basic attributes' do
    it { should belong_to(:library) }
    it { should have_many(:reservable_assets) }
#    it { should have_many(:reservation_expiration_notices) }
#    it { should have_many(:user_types) }
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
#    it 'has reservable_assets' do
#      @assets = ReservableAsset.find_by_reservable_asset_type_id(@reservable_asset_type)
#      @reservable_asset_type.reservable_assets.should == @assets
#    end

  end
end