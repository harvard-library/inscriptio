class UserType < ActiveRecord::Base
  attr_accessible :name, :user_ids, :reservable_asset_type_ids

  has_many :users, :dependent => :destroy
  has_and_belongs_to_many :reservable_asset_types

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    %Q|#{name}|
  end
end
