class BillPresenter < BasePresenter
  def month
    h.t("date.month_names")[@model.tab.month]
  end

  def number
    @model.number
  end

  def date
    @model.created_at.to_date
  end

  def discount
    @model.discount
  end

  def user
    "#{@model.tab.user.first_name} #{@model.user.last_name}"
  end

  def items
    @model.items || []
  end

  def amount
    h.number_to_currency(@model.amount, unit: '€', format: '%n %u')
  end

  def self.serialized_items(tab_items)
    tab_items.map do |item|
      {
        title: item.product.title,
        quantity: item.quantity,
        price: item.total_price
      }
    end
  end
end
