require 'spec_helper'

describe Reservation do
  context 'has basic attributes' do
    it { should belong_to(:reservable_asset) }
#    it { should belong_to(:user) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }

    it { should have_db_index(:reservable_asset_id) }
#    it { should have_db_index(:user_id) }
  end
end

describe 'A reservation object' do
  fixtures :all
  before :each do
    @reservation = Reservation.find(:first)
  end
  
#  context do
#    it 'has a user' do
#      @reservation.user.should == User.find_by_reservation_id(@reservation)
#    end
#  end
end