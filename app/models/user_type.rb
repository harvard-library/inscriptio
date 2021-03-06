class UserType < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)

  belongs_to :library

  has_and_belongs_to_many :users
  has_and_belongs_to_many :reservable_asset_types

  validates :name, :presence => true, :uniqueness => {:scope => :library_id}

  def to_s
    %Q|#{name}|
  end
end
