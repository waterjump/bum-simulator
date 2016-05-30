class Consume < Bum::Action
  def initialize(bum, options = {})
    super
    @action_name = :consume
    @grocery = ::Grocery.find(options[:grocery_id])
  end

  def perform
    return unless check_price(@grocery.price)
    @result.update(
      calories: @grocery.calories,
      energy:   @grocery.energy,
      life:     @grocery.life,
      money:    (@grocery.price * -1)
    )
    write_in_diary(
      "You consumed #{grocery_article} #{@grocery.name}.",
      money: @grocery.price * -1,
      calories: @grocery.calories,
      life: @grocery.life,
      energy: @grocery.energy
    )
    @grocery.time_spent.times { pass_one_hour(0) } if @grocery.time_spent > 0
    @result.apply
  end

  def grocery_article
    @grocery.countable ? 'a' : 'some'
  end

  def check_price(price)
    affordable = price <= @bum.money
    write_in_diary('You don\'t have enough money for that.') unless affordable
    affordable
  end
end
