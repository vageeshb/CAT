class TestStep < ActiveRecord::Base
	has_one :object_repository
	belongs_to :test
	validates_presence_of :step_name
end
