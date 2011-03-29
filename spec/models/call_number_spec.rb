require 'spec_helper'

describe CallNumber do

  context 'has basic attributes' do
    it { should have_and_belong_to_many(:floors) }
    it { should validate_presence_of(:call_number) }
    it { should have_db_index(:call_number) }
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
  
end
