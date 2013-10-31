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

  before :each do
    @subject_area = FactoryGirl.build(:subject_area)
  end

  context do
    it 'talks about itself' do
      expect(@subject_area.to_s).to eq(@subject_area.name)
      expect(@subject_area.name).not_to be(nil)
    end
  end

  context do
    it 'has call_numbers' do
      @subject_area.call_numbers.each do |f|
        expect(f).to be_a(CallNumber)
      end
    end
  end

  context do
    it 'has floors' do
      @subject_area.floors.each do |f|
        expect(f).to be_a(Floor)
      end
    end
  end

end
