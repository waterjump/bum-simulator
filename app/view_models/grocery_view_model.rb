class GroceryViewModel < ApplicationViewModel

  def respond_to?(*args)
    super || (model && model.respond_to?(*args))
  end

  def available?(hour)
    model.availability[hour]
  end

  def purchaseable?(money)
    model.price <= money
  end

  def dollars
    model.price / 100.0
  end
end
