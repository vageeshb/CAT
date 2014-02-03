class ObjectRepository < ActiveRecord::Base
	self.inheritance_column = nil

	has_many :web_elements, dependent: :destroy
	belongs_to :user

	validates_presence_of :name, :description, :url
end
