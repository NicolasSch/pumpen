class User < ApplicationRecord
  AVAILABLE_MEMBERSHIPS = %w(staff full four three two one guest)
  ROLES = %w(admin user)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tabs, dependent: :destroy
  has_many :bills, through: :tabs
  has_many :tab_items, through: :tabs
  has_many :products, through: :tab_items
  has_one :cart

  scope :active,    -> { where(archived: false) }
  scope :archived,  -> { where(archived: true) }
  scope :name_like, ->(name) { where("(concat(first_name, ' ', last_name) like ?) OR (concat(last_name, ' ', first_name) like ?)","%#{name}%", "%#{name}%") }

  def most_used_products
    products.group(:id).order('count(products.id) desc')
  end

  def admin?
    role == 'admin'
  end

  def staff_member?
    membership == 'staff'
  end

  def full_member?
    membership == 'full'
  end

  def tab_manager?
    admin? || staff_member? || full_member?
  end

  # Need to override devise method to send email asynchronously
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def active_for_authentication?
    super and !self.archived?
  end

  def queue_open_bills_reminder
    NotificationMailer.open_bills_reminder(self).deliver_later
  end
end
