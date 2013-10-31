require 'spec_helper'

describe CallNumber do

  context 'has basic attributes' do
    it { should have_and_belong_to_many(:floors) }
    it { should validate_presence_of(:call_number) }
    it { should validate_uniqueness_of(:call_number) }
    it { should have_db_index(:call_number) }
    it { should have_db_index(:subject_area_id) }
    it { should ensure_length_of(:call_number).is_at_least(1).is_at_most(50) }
    it { should ensure_length_of(:description).is_at_least(0).is_at_most(16.kilobytes) }
  end

end

describe 'a call_number object' do

  before :each do
    @call_number = FactoryGirl.build(:call_number, :floors => FactoryGirl.build_list(:floor, 3))
  end

  context do
    it 'talks about itself' do
      expect(@call_number.to_s).to eq(@call_number.call_number)
    end
  end

  context do
    it 'has floors' do
      expect(@call_number.floors.first).to be_a(Floor)
    end
  end

end
