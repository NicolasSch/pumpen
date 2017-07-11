class DeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    super
  end

  def reset_password_instructions(record, token, opts={})
    super
  end

  def password_change(record, opts={})
    super
  end
end
