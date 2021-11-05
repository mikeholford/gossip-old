class Account < ApplicationRecord  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :rooms
  has_many :webhook_endpoints

  validates_presence_of :username

  has_secure_token :api_token, length: 56

  extend FriendlyId
  friendly_id :username, use: :slugged

  # Class Methods
  def self.authenticate_token(token)
    Account.find_by(api_token: token)
  end

  def is_admin?
    true
  end

end
