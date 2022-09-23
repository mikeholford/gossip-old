class User < ApplicationRecord

  belongs_to :account, optional: true

  has_many :memberships
  has_many :rooms, through: :memberships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: { case_sensitive: false }, presence: true, allow_blank: false, format: { with: /\A[a-zA-Z0-9]+\z/ }

  # TODO: Do We restrict users to accounts. API will login any users atm.

  def is_member?(room)
    rooms.include?(room)
  end

  def generate_jwt
    # In production this key will be set using an environment variable
    JWT.encode({ id: id, exp: 10.minutes.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

end
