class Admin::TabsController < AdminController
  def index
    @tabs = Tab.all
  end

  def update
  end
end
