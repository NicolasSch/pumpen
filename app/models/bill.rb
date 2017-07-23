class Bill < ActiveRecord::Base
  belongs_to :tab
  before_save :add_number
  belongs_to :tab
  has_one :user, through: :tab

  has_many :products, through: :tab

  serialize :items

  after_create :queue_bill_added_mail

  scope :name_like, ->(name) { joins(:user).where("(concat(first_name, ' ', last_name) like ?) OR (concat(last_name, ' ', first_name) like ?)","%#{name}%", "%#{name}%") }

  def queue_bill_added_mail
    NotificationMailer.bill_added(self.user).deliver_later
  end

  private

  def add_number
    self.number = "RG-#{self.tab.user.id}-#{Date.today.year}-#{tab.month}"
  end
end
