require 'spec_helper'
require 'carrierwave/test/matchers'

describe Floor do
  context 'has basic attributes' do
    it { should belong_to(:library) }
    it { should have_and_belong_to_many(:call_numbers) }
    it { should have_many(:reservable_assets) }
    it { should validate_presence_of(:library_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:floor_map) }

    it { should respond_to(:move_higher) }
    it { should respond_to(:move_lower) }

    it { should have_db_index(:library_id) }
    it { should have_db_index(:position) }
    it { should have_db_index(:floor_map) }
  end
end

describe 'A floor object' do
  fixtures :all
  before :each do
    @floor = Floor.find_by_name('Floor 1')
  end
  context do
    it "talks about itself" do
      @floor.to_s.should == 'Floor 1'
      @floor.to_s.should_not == 'asdf'
    end
    it "can be reordered" do
      @floor.position.should == 1
      assert ! @floor.move_higher
      @floor.position.should == 1
      assert @floor.move_lower
      @floor.position.should_not == 1
      @floor.position.should == 2
    end

    it "has a floor_map" do
      @floor.floor_map = File.open('public/images/rails.png')
      assert @floor.save
      assert ! @floor.floor_map.blank?
      @floor.floor_map.size.should > 0
    end

  end
end
