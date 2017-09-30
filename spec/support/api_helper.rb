module ApiHelper
  def authenticate
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic
      .encode_credentials(ApiController::USERNAME,
                          ApiController::PASSWORD)
  end
end
