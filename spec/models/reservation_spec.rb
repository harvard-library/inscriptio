require 'spec_helper'

describe Reservation do
  context 'has basic attributes' do
    it { should belong_to(:reservable_asset) }
    it { should belong_to(:user) }
    it { should have_db_index(:reservable_asset_id) }
    it { should have_db_index(:user_id) }
  end
end

describe 'A reservation object' do
  before :each do
    @reservation = FactoryGirl.build_stubbed(:reservation)
  end

  context do
    it 'has a user' do
      expect(@reservation.user).to be_a User
    end
  end
end
