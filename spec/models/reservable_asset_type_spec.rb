require 'spec_helper'

describe ReservableAssetType do
  context 'has basic attributes' do
    it { should belong_to(:library) }
    it { should have_many(:reservable_assets) }
    it { should have_many(:reservation_notices) }
    it { should have_and_belong_to_many(:user_types) }
    it { should validate_presence_of(:library_id) }
    it { should validate_presence_of(:name) }
    it { should have_db_index(:library_id) }
    it { should have_db_index(:name) }
  end
end

describe 'A reservable_asset_type object' do
  before :each do
    @reservable_asset_type = FactoryGirl.build(:reservable_asset_type)
  end
  context do
    it "talks about itself" do
      expect(@reservable_asset_type.to_s).to eq(@reservable_asset_type.name)
      expect(@reservable_asset_type.to_s).not_to be(nil)
    end

    it 'has reservable_assets' do
      @reservable_asset_type.reservable_assets.each do |ra|
        expect(ra).to be_a(ReservableAsset)
      end
    end

    it 'has user_types' do
      @reservable_asset_type.user_types.each do |ut|
        expect(ut).to be_a(UserType)
      end
    end

    it "has a photo" do
      @reservable_asset_type.photo = File.open('public/images/rails.png')
      expect { @reservable_asset_type.save! }.not_to raise_error
      expect(@reservable_asset_type.photo).not_to be_blank
      expect(@reservable_asset_type.photo.size).to be > 0
    end

  end
end
