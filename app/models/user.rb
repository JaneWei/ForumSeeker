# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

class User < ActiveRecord::Base

  attr_accessible :email, :name, :password_confirmation, :password 

  has_secure_password#automatically check the user password 
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token  
  before_create { generate_token(:auth_token)}
 

  validates :name, presence: true, length:{ maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #To make sure email address validation robust
  validates :email, presence: true, format:{ with: VALID_EMAIL_REGEX},
                    uniqueness:{ case_sensitive: false} 
	# delete them for forgotten method
  #validates :password, length:{ minimum: 6}
  #validates :password_confirmation, presence: true

  def send_password_reset
		generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
		begin		
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
  end

  private
  # could use it later
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end  

end
