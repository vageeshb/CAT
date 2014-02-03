class WebElement < ActiveRecord::Base
	self.inheritance_column = nil
	validates_presence_of :page_name, :element_name, :element_type, :identifier_name, :identifier_value

	belongs_to :object_repository
end
