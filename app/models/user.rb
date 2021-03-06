class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :pro
  has_secure_password
  
  
  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, format: { with: valid_email_regex }
  validates :email, uniqueness: true
  #validates :password, length: { within: 6..50 }
  
  before_save :create_remember_token, :create_username
  
  def to_param
    "#{id}-#{username.gsub(/[^a-z0-9]+/i, '-')}"
  end
    
  # associations
  has_many :resumes
  has_many :payment_notifications
  
  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.now
    self.save!
    UserMailer.password_reset(self).deliver
  end
  

  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
    def create_username
      self.username = email.split('@')[0]
    end

end
