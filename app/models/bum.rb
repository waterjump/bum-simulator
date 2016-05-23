class Bum
  include Mongoid::Document

  field :user_id, type: String
  field :money, type: Integer, default: 0
  field :energy, type: Integer, default: 16
  field :calories, type: Integer, default: 1000
  field :appeal, type: Integer, default: 10
  field :diary, type: Hash, default: {}
  field :time, type: DateTime, default: BumSimulator::Application.config.starting_date_time
  field :life, type: Integer, default: 1000

  def self.find_or_initialize(user_id)
    where(user_id: user_id).first || create!
  end

  def panhandle
    gonna_die
    earnings = (5 * appeal * luck * (life/1000.0)) # cents
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

  def drink_beer
    return unless check_price(250)
    self.money -= 350
    self.life += 200
    self.life = 1000 if self.life >= 1000
    write_in_diary("You drank a beer.")
    save
  end

  def rummage
    # TODO
  end

  def eat(food_id)
    food = Food.find(food_id)
    self.money -= food.price
    self.calories += food.calories
    write_in_diary("You ate a #{food.name}.")
    save
  end

  private

  def health_check

  end

  def gonna_die
    return unless self.life <= 300
    write_in_diary("You feel like death.")
  end

  def check_price(price)
    result = price <= self.money
    write_in_diary('You don\'t have enough money for that.')
    result
  end

  def format_money(amount)
    "$#{(amount/100.00).round(2)}"
  end

  def get_robbed_in_sleep
    return if luck >= 0.74 # One in 14 chance
    amount = self.money * 0.4 * luck
    self.money -= amount
    write_in_diary("You got robbed while asleep for #{format_money(amount)}! Fuck!")
  end

  def pass_one_hour(calories = 100, sleeping = false)
    self.time += 1.hour
    self.energy -= 1 unless sleeping
    self.calories -= calories
    if self.energy <= 0
      self.life -= 100
      self.energy = 0
    end
    if self.calories <= 0
      self.life -= calories * 1
      self.calories = 0
    end
  end

  def write_in_diary(entry)
    puts "#{time.strftime('%b %-d, %Y')}: #{entry}"
    if diary["#{time.to_s}"].present?
      diary["#{time.to_s}"] += "  #{entry}"
    else
      diary.merge!("#{time.to_s}" => entry)
    end
  end

  def luck
    # random number between 0.70 and 1.30
    (Random.new.rand(60) + 70.0) / 100.0
  end
end
