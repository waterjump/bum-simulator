class GroceryViewModel < ApplicationViewModel
  def respond_to?(*args)
    super || (model && model.respond_to?(*args))
  end

  def available?(bum)
    day_of_week = bum.time.strftime('%A').downcase.to_sym
    model.available_days.include?(day_of_week) &&
      model.availability[bum.time.hour.to_s] &&
      soup_condition(bum)
  end

  def purchaseable?(money)
    model.price <= money
  end

  def dollars
    model.price / 100.0
  end

  def button_text
    model.special_action ||
      "#{I18n.t(model.verb + '.present').titleize} #{model.name.downcase}"
  end

  private

  def soup_condition(bum)
    (model.name == 'soup' && !bum.ate_soup_today?) ||
      model.name != 'soup'
  end
end
