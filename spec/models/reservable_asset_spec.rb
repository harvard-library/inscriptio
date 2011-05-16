require 'spec_helper'

describe ReservableAsset do
  context 'has basic attributes' do
    it { should belong_to(:floor) }
    it { should belong_to(:reservable_asset_type) }
    it { should have_many(:reservations) }
    it { should have_one(:bulletin_board) }
#    it { should have_many(:users) }
    it { should validate_presence_of(:floor_id) }
    it { should validate_presence_of(:reservable_asset_type_id) }

    it { should have_db_index(:floor_id) }
    it { should have_db_index(:reservable_asset_type_id) }
  end
end

describe 'A reservable_asset object' do
  fixtures :all
  before :each do
    @reservable_asset = ReservableAsset.find(:first)
  end
  context do
    it 'has a bulletin_board' do
      @reservable_asset.bulletin_board.should == BulletinBoard.find_by_reservable_asset_id(@reservable_asset)
    end

  end
end