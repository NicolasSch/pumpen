class Bill < ActiveRecord::Base
  belongs_to :tab
  before_save :add_number

  private

  def add_number
    self.number = "RG-#{self.tab.user.id}-#{Date.today.year}-#{tab.month}"
  end
end
