class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_save :create_remember_token
  has_secure_password
  
  validates :name, presence: true, length: { maximum: 50 }  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }  
                                    
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }
  
  private
    def encrypt_password
      self.encrypted_password = encrypt(password)
    end
    def encrypt(string)
      string # Only a temporary implementation!
    end
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
