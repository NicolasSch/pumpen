# frozen_string_literal: true

class ApiController < ActionController::Base
  USERNAME = 'cfhh'
  PASSWORD = 'bis1Stirbt'

  before_action :authenticate

  rescue_from ActionController::ParameterMissing, with: :rescue_from_parameter_missing
  rescue_from ActiveRecord::RecordNotFound,       with: :rescue_from_record_not_found
  rescue_from ActiveRecord::RecordInvalid,        with: :rescue_from_record_invalid

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end

  def rescue_from_record_invalid
    render json: { error: 'something went wrong' }, status: :unprocessable_entity
  end

  def rescue_from_parameter_missing(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def rescue_from_record_not_found
    render json: { error: 'not found' }, status: :not_found
  end
end
