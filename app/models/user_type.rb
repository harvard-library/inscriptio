class UserType < ActiveRecord::Base
  has_many :users
  has_and_belongs_to_many :reservable_asset_types
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_s
    %Q|#{name}|
  end
end
