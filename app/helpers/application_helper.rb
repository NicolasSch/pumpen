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

  def translated_month(month)
    t("date.month_names")[month]
  end

  def product_group_select(product)
    collection = product.map { |product| [product.product_group, product.product_group] }.uniq
    collection.sort { |a,b| a[0] <=> b[0] }
  end

  def show_new_tag?(product)
    ((Time.now.to_f - product.created_at.to_f).to_f/60/60/24).to_i < 30
  end
end
