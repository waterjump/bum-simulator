class ItemViewModel < ApplicationViewModel
  def respond_to?(*args)
    super || (model && model.respond_to?(*args))
  end

  def affordable?(money)
    model.price <= money
  end

  def dollars
    model.price / 100.0
  end

  def button_text
    "Buy #{model.name.downcase}"
  end
end
