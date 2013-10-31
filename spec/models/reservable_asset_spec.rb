require 'spec_helper'

describe ReservableAsset do
  context 'has basic attributes' do
    it { should belong_to(:floor) }
    it { should belong_to(:reservable_asset_type) }
    it { should have_many(:reservations) }
    it { should have_one(:bulletin_board) }
    it { should have_many(:users) }
    it { should validate_presence_of(:floor_id) }
    it { should validate_presence_of(:reservable_asset_type_id) }

    it { should have_db_index(:floor_id) }
    it { should have_db_index(:reservable_asset_type_id) }
  end
end

describe 'A reservable_asset object' do
  before :each do
    @reservable_asset = FactoryGirl.build(:reservable_asset)
  end
  context do
    it 'has a bulletin_board'

    it 'has reservations' do
      @reservable_asset.reservations.each do |r| expect(r).to be_a(Reservation) end
    end

    it "has a photo" do
      @reservable_asset.photo = File.open('public/images/rails.png')
      expect {@reservable_asset.save!}.not_to raise_error
      expect(@reservable_asset.photo).not_to be_blank
      expect(@reservable_asset.photo.size).to be > 0
    end

  end
end
