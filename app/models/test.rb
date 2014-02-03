class Test < ActiveRecord::Base
	belongs_to :test_suite
	has_many :test_steps, dependent: :destroy
	
	validates_presence_of :name,:description
end
