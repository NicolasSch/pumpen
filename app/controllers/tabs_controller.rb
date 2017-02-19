class TabsController < ApplicationController
  before_action :ensure_tab, :set_tab, only: :index

  def index
    authorize! :read, @tab
    @tab_item = TabItem.new
  end

  private

  def ensure_tab
    current_user.tabs.first_or_create!(month: Time.now.month)
  end
end
