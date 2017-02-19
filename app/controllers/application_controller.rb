class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

  def set_tab
    @tab = current_user.tabs.tab_of_the_month
  end
end
