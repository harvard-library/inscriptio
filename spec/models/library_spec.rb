require 'spec_helper'

describe Library do
  context 'has basic attributes' do
    [:name, :address_1, :city, :state, :zip].each do|col|
      it { should validate_presence_of(col) }
    end
    it { should have_many(:floors) }
    it { should have_many(:reservable_asset_types) }
    it { should allow_value('http://foo.com').for(:url) }
    it { should allow_value('').for(:url) }
    it { should_not allow_value('foo.com').for(:url).with_message(/is invalid/) }
    it { should ensure_length_of(:description).is_at_least(0).is_at_most(16.kilobytes) }
    it { should ensure_length_of(:contact_info).is_at_least(0).is_at_most(16.kilobytes) }
  end
end

describe 'A library' do

  before :all do
    @library = FactoryGirl.build(:library)
    @library.floors << FactoryGirl.build_list(:floor, 2, :library => @library)
  end
  context do
    it "talks about itself" do
      expect(@library.to_s).to eq(@library.name)
      expect(@library.to_s).not_to eq(nil)
    end

    it 'has floors' do
      @library.floors.each { |floor| expect(floor).to be_an_instance_of Floor }
    end
  end

end
