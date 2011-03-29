require 'spec_helper'
require 'carrierwave/test/matchers'

describe Floor do
  include CarrierWave::Test::Matchers

  it { should belong_to(:library) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:move_higher) }
  it { should have_db_index(:library_id) }
  it { should have_db_index(:position) }
  it { should have_db_index(:floor_map) }


end
