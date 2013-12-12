class Message < ActiveRecord::Base
  attr_accessible :title, :content, :description
end
