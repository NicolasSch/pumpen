# frozen_string_literal: true

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
    [[t('user.male'), 'male'], [t('user.female'), 'female']]
  end

  def translated_month(month)
    t('date.month_names')[month]
  end

  def product_group_select(products)
    collection = products.map { |product| [product.product_group, product.product_group] }.uniq
    collection.sort_by { |a| a[0] }
  end

  def show_new_tag?(product)
    ((Time.zone.now.to_f - product.created_at.to_f).to_f / 60 / 60 / 24).to_i < 30
  end

  def translates_month_collection
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map { |month| [translated_month(month), month] }
  end
end
