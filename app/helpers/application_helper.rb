module ApplicationHelper
  def number_to_euro(amount)
    number_to_currency(amount, unit: '€', format: '%n %u')
  end

  def translated_memberships
    User::AVAILABLE_MEMBERSHIPS.map do |membership|
      [t("user.membership.#{membership}"), membership]
    end
  end

  def translated_genders
    [[t('user.male'), 'male'],[t('user.female'), 'female']]
  end
end
