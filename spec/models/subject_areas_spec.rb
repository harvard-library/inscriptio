require 'spec_helper'

describe SubjectArea do
  context 'has basic attributes' do
    it { should have_and_belong_to_many(:floors) }
    it { should have_many(:call_numbers) }
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:description).is_at_least(0).is_at_most(16.kilobytes) }

    it { should have_db_index(:name) }
  end
end

describe 'a subject_area object' do
  fixtures :all
  before :each do
    @subject_area = SubjectArea.find_by_name('Archeology')
  end

  context do
    it 'talks about itself' do
      @subject_area.to_s.should == 'Archeology'
      @subject_area.to_s.should_not == '4324324'
    end
  end

  context do
    it 'has call_numbers' do
      @subject_area.call_numbers.should == [CallNumber.find_by_call_number('CN-3'),CallNumber.find_by_call_number('CN-2'),CallNumber.find_by_call_number('CN-1')]
      @subject_area.call_numbers.first.destroy
      @subject_area.reload
      @subject_area.call_numbers.should == [CallNumber.find_by_call_number('CN-2'),CallNumber.find_by_call_number('CN-1')]
    end
  end
  
  context do
    it 'has floors' do
      @subject_area.floors.should == [Floor.find_by_name('Floor 1'),Floor.find_by_name('Floor 3'),Floor.find_by_name('Floor 4')]
      @subject_area.floors.first.destroy
      @subject_area.reload
      @subject_area.floors.should == [Floor.find_by_name('Floor 3'),Floor.find_by_name('Floor 4')]
    end
  end
  
end