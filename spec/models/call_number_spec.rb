require 'spec_helper'

describe CallNumber do

  context 'has basic attributes' do
    it { should have_and_belong_to_many(:floors) }
    it { should validate_presence_of(:call_number) }
    it { should validate_uniqueness_of(:call_number) }
    it { should have_db_index(:call_number) }
    it { should ensure_length_of(:call_number).is_at_least(1).is_at_most(50) }
    it { should ensure_length_of(:description).is_at_least(0).is_at_most(16.kilobytes) }
  end

end

describe 'a call_number object' do
  fixtures :all
  before :each do
    @call_number = CallNumber.find_by_call_number('CN-1')
  end

  context do
    it 'talks about itself' do
      @call_number.to_s.should == 'CN-1'
      @call_number.to_s.should_not == 'Call Number 1'
    end
  end

  context do
    it 'has floors' do
      @call_number.floors.should == [Floor.find_by_name('Floor 1'),Floor.find_by_name('Floor 3'),Floor.find_by_name('Floor 4')]
      @call_number.floors.first.destroy
      @call_number.reload
      @call_number.floors.should == [Floor.find_by_name('Floor 3'),Floor.find_by_name('Floor 4')]
    end
  end
  
end
