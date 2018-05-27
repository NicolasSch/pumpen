class PoliciesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def imprint; end

  def data_policy; end
end