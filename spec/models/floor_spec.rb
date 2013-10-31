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
  before :all do
    @library = FactoryGirl.create(:library)
    @library.floors << FactoryGirl.create_list(:floor, 5, :library => @library)
  end
  before :each do
    @floorA = @library.floors(true).first
    @floorZ = @library.floors(true).last
  end
  context do
    it "talks about itself" do
      expect(@floorA.to_s).to eq(@floorA.name)
      expect(@floorA.to_s).not_to be(nil)
    end
    context "can be reordered" do
      it "cannot move up past first position" do
        expect(@floorA).to eq(@library.floors(true).first)
        @floorA.move_higher
        expect(@floorA).to eq(@library.floors(true).first)
      end

      it "can move down" do
        expect(@floorA).to eq(@library.floors(true).first)
        @floorA.move_lower
        expect(@floorA).to eq(@library.floors(true).all[1])
        expect(@floorA).not_to eq(@library.floors(true).first)
      end

      it "can move up" do
        expect(@floorZ).to eq(@library.floors(true).last)
        @floorZ.move_higher
        expect(@floorZ).to eq(@library.floors(true).all[-2])
        expect(@floorZ).not_to eq(@library.floors(true).last)
      end

    end

    it "has a floor_map" do
      @floorA.floor_map = File.open('public/images/rails.png')
      expect{@floorA.save!}.not_to raise_error
      expect(@floorA.floor_map).not_to be_blank
      expect(@floorA.floor_map.size).to be > 0
    end

  end
end
