class TabsController < ApplicationController
  before_action :ensure_tab

  def index
    tab = current_user.tabs.where(month: month).first!
    @tab = tab.dup
    authorize! :read, @tab
    @tab_item = tab.tab_items.build
  end

  private

  def ensure_tab
    current_user.tabs.first_or_create!(month: month)
  end

  def month
    Time.now.month
  end
end
