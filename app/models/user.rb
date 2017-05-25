class User < ApplicationRecord
  AVAILABLE_MEMBERSHIPS = %w(staff full four three two one guest)
  ROLES = %w(admin user)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tabs
  has_many :bills, through: :tabs
  has_one :cart

  def admin?
    role == 'admin'
  end

  def staff_member?
    membership == 'staff'
  end

  # Need to override devise method to send email asynchronously
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
