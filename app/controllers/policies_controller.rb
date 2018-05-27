class PoliciesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def imprint; end

  def data_policy
    send_file 'public/Datenschutzerklärung-DSGVO-2018.pdf'
  end
end