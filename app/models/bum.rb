class Bum
  include Mongoid::Document

  field :user_id, type: String
  field :money, type: Integer, default: 0
  field :energy, type: Integer, default: 16
  field :calories, type: Integer, default: 600
  field :appeal, type: Integer, default: 10
  field :diary, type: Hash, default: {}
  field :time, type: DateTime, default: BumSimulator::Application.config.starting_date_time
  field :life, type: Integer, default: 1000
  field :total_panhandled, type: Integer, default: 0
  field :total_robbed, type: Integer, default: 0
  field :items, type: Array, default: []

  def self.find_or_initialize(user_id)
    where(user_id: user_id).first || create!
  end

  def panhandle
    gonna_die
    slim_jim if rand1000 % 24 == 0
    earnings = (5 * total_appeal * luck * life_factor * traffic) # cents
    self.money += earnings if earnings > 0
    write_in_diary("You panhandled for one hour and made #{format_money(earnings)}.")
    pass_one_hour
    save
  end

  def sleep(hours)
    self.energy += hours * 2
    self.energy = 16 if self.energy > 16
    get_robbed_in_sleep
    s = hours > 1 ? 's' : ''
    write_in_diary("You slept for #{hours} hour#{s}.")
    hours.times { pass_one_hour(100, true) }
    save
  end

  def consume(grocery_id)
    grocery = Grocery.find(grocery_id)
    return unless check_price(grocery.price)
    self.money -= grocery.price
    self.calories += grocery.calories if grocery.calories != 0
    self.energy += grocery.energy if grocery.energy != 0
    self.life += grocery.life if grocery.life != 0
    regulate_metrics
    write_in_diary(
      "You #{grocery.verb} #{grocery_article(grocery)} #{grocery.name}."
    )
    save
  end

  def rummage
    find_cans
    pizza_crust if rand1000 % 3 == 0
    Item.rummageable.each do |item|
      next unless item.rummageable_date <= self.time
      add_item(item) if rand1000 % item.rummage_chance == 0
    end
    write_in_diary('You rummaged for an hour.')
    pass_one_hour(200)
    save
  end

  private

  def find_cans
    cans = rand1000 % 10
    return unless cans > 0
    earnings = cans * 5
    self.money += earnings
    write_in_diary("You found #{cans} cans and cashed them in for #{format_money(earnings)}.")
  end

  def total_appeal
    self.appeal
    item_appeal =
      items.inject(0) do |memo, item_id|
        item = Item.find(item_id)
        memo + item.appeal
      end
    self.appeal + item_appeal
  end

  def add_item(item)
    return if self.items.include?(item.id.to_s)
    self.items << item.id.to_s
    write_in_diary("You found #{ item.description || item.name }.  Appeal increased by #{ item.appeal }!")
  end

  def pizza_crust
    self.calories += 50
    regulate_metrics
    write_in_diary('You found some pizza crust in a dumpster and ate it.')
  end

  def slim_jim
    self.calories += 100
    regulate_metrics
    write_in_diary("Some kid gave you a slim jim.")
  end

  def rand1000
    (1..1000).to_a.sample
  end

  def traffic
    time_table = {
      0 => 0.4,
      1 => 0.3,
      2 => 0.2,
      3 => 0.2,
      4 => 0.2,
      5 => 0.2,
      6 => 0.4,
      7 => 1.2,
      8 => 1.2,
      9 => 1.0,
      10 => 1.0,
      11 => 1.0,
      12 => 1.2,
      13 => 1.1,
      14 => 1.0,
      15 => 1.0,
      16 => 1.0,
      17 => 1.2,
      18 => 1.2,
      19 => 1.0,
      20 => 0.85,
      21 => 0.7,
      22 => 0.6,
      23 => 0.5
    }
    time_table[self.time.hour]
  end

  def life_factor
    self.life >= 300 ? 1 : 0.5
  end

  def regulate_metrics
    self.life = 1000 if self.life > 1000
    self.energy = 16 if self.energy > 16
    self.calories = 600 if self.calories > 600
  end

  def grocery_article(grocery)
    grocery.countable ? 'a' : 'some'
  end

  def health_check

  end

  def gonna_die
    return unless self.life <= 300
    write_in_diary("You feel like death.")
  end

  def check_price(price)
    result = price <= self.money
    write_in_diary('You don\'t have enough money for that.') unless result
    result
  end

  def format_money(amount)
    "$#{(amount/100.00).round(2)}"
  end

  def get_robbed_in_sleep
    return unless rand1000 % 14 == 0
    amount = self.money * 0.4 * luck
    self.money -= amount
    self.total_robbed += amount
    write_in_diary("You got robbed while asleep for #{format_money(amount)}! Fuck!")
  end

  def pass_one_hour(calories = 100, sleeping = false)
    self.time += 1.hour
    self.energy -= 1 unless sleeping
    self.calories -= calories
    if self.energy <= 0
      self.life -= 20
      self.energy = 0
    end
    if self.calories <= 0
      self.life -= calories * 0.2
      self.calories = 0
    end
  end

  def write_in_diary(entry)
    puts "#{time.strftime('%b %-d, %Y')}: #{entry}"
    if diary["#{time.to_s}"].present?
      diary["#{time.to_s}"] += "\n#{entry}"
    else
      diary.merge!("#{time.to_s}" => entry)
    end
  end

  def luck
    # random float between 0.70 and 1.30
    (Random.new.rand(60) + 70.0) / 100.0
  end
end
