require 'spec_helper'

describe BulletinBoard do
  context 'has basic attributes' do
    it { should have_many(:posts) }
    it { should have_many(:users) }
    it { should belong_to(:reservable_asset) }
    it { should have_db_index(:reservable_asset_id) }
  end
end

describe 'a bulletin_board object' do
  before :each do
    @bulletin_board = FactoryGirl.build(:bulletin_board)
  end

  context do
    pending
  end

end
