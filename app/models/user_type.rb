class UserType < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  attr_accessible :name, :user_ids, :reservable_asset_type_ids, :library_id

  belongs_to :library

  has_and_belongs_to_many :users
  has_and_belongs_to_many :reservable_asset_types

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    %Q|#{name}|
  end
end
