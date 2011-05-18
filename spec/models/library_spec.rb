require 'spec_helper'

describe Library do
  context 'has basic attributes' do
    [:name, :address_1, :city, :state, :zip].each do|col|
      it { should validate_presence_of(col) }
    end
    it { should have_many(:floors) }
    it { should have_many(:reservable_asset_types) }
    it { should validate_format_of(:url).with('http://foo.com') }
    it { should validate_format_of(:url).with('') }
    it { should validate_format_of(:url).not_with('foo.com').with_message(/is invalid/) }
    it { should ensure_length_of(:description).is_at_least(0).is_at_most(16.kilobytes) }
    it { should ensure_length_of(:contact_info).is_at_least(0).is_at_most(16.kilobytes) }
  end
end

describe 'A library' do
  fixtures :all
  before :each do
    @library = Library.find_by_name('Widener')
  end
  context do 
    it "talks about itself" do
      @library.to_s.should == 'Widener'
    end
    
    it 'has floors' do
      @library.floors.should == @library.floors
    end
  end

end
