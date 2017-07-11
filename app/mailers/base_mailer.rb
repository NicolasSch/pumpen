class BaseMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'CrossFit HH Service <service@cfhh-tab.de>'

  private

  def default_url_options
    super.merge(host: host)
  end

  def host
    Rails.configuration.action_mailer.default_url_options[:host]
  end

  def mail_with_defaults(options = {})
    default_options = {
      from: 'CrossFit HH Service <service@cfhh-tab.de>',
      reply_to: 'CrossFit HH Service <service@cfhh-tab.de>',
    }
    mail(default_options.merge(options))
  end
end
