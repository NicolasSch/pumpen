# frozen_string_literal: true

module ControllerHelpers
  def sign_in(user, scope: nil)
    super
    session[:two_factor_authenticated] = true
  end
end
