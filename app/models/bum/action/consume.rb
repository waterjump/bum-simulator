class Consume < Bum::Action
  def initialize(bum, options = {})
    super
    @action_name = :consume
    @grocery = ::Grocery.find(options[:grocery_id])
  end

  def perform
    return unless check_price(@grocery.price)
    @bum.change_vitals(
      @grocery.calories,
      @grocery.energy,
      @grocery.life,
      (@grocery.price * -1)
    )
    write_in_diary(
      "You consumed #{grocery_article} #{@grocery.name}.",
      money: @grocery.price * -1,
      calories: @grocery.calories,
      life: @grocery.life,
      energy: @grocery.energy
    )
    @bum.save!
  end

  def grocery_article
    @grocery.countable ? 'a' : 'some'
  end

  def check_price(price)
    result = price <= @bum.money
    write_in_diary('You don\'t have enough money for that.') unless result
    result
  end
end
