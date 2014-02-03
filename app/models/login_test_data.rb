class LoginTestData < ActiveRecord::Base
	validates :email, presence: true
	validates :password, presence: true
	#validates :check, presence: true
end
