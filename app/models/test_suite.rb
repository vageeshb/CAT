class TestSuite < ActiveRecord::Base
	has_many :tests, dependent: :destroy
	has_many :test_steps, through: :tests
	belongs_to :user
	
	validates_presence_of :name
	validates_uniqueness_of :name, :on => :create, :message => "has already been used"
end
