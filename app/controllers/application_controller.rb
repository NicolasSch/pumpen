# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_raven_context

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied, with: :access_denied_handler
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = %i[password password_confirmation current_password]
    devise_parameter_sanitizer.permit(:account_update, keys: update_attrs)
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :terms, :first_name, :last_name, :email, :member_number, :street, :city, :zip, :iban, :bic, :bank
    ])
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def record_not_found_handler
    redirect_to :root, alert: t('not_found')
  end

  def access_denied_handler
    redirect_to :root, alert: t('access_denied')
  end
end
