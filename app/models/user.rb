class User < ActiveRecord::Base
	has_many :object_repositories
	has_many :test_suites

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates_presence_of :email,:password
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false }
	has_secure_password
  	validates :password, length: { minimum: 6 }
	
  	has_one :selenium_config
  	has_many :queue_carts
  	after_create :create_error_dir

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def create_error_dir
		dir = self.email.to_s
		Dir.mkdir("./public/errors/"+dir) unless File.exists?("./public/errors/"+dir)
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
