class User < ApplicationRecord
  AVAILABLE_MEMBERSHIPS = %w(staff full four three two one guest)
  ROLES = %w(admin user)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tabs
  has_one :cart

  def admin?
    role == 'admin'
  end
end
