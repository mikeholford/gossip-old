class User < ApplicationRecord
  
  has_many :memberships
  has_many :rooms, through: :memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :set_username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_uniqueness_of :username

  def is_member?(room)
    rooms.include?(room)
  end


  private

  def set_username
    self.update(username: SecureRandom.hex(10))
  end

end
