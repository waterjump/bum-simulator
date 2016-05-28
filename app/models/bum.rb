class Bum
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: String
  field :money, type: Integer, default: 0
  field :energy, type: Integer, default: 16
  field :calories, type: Integer, default: 600
  field :appeal, type: Integer, default: 10
  field :diary, type: Hash, default: {}
  field :time,
    type:    DateTime,
    default: BumSimulator::Application.config.starting_date_time
  field :life, type: Integer, default: 1000
  field :total_panhandled, type: Integer, default: 0
  field :total_robbed, type: Integer, default: 0
  field :items, type: Array, default: []
  embeds_one :diary,
    class_name: 'Bum::Diary',
    cascade_callbacks: true
  belongs_to :location,
    class_name: 'Location'

  def self.find_or_initialize(user_id)
    where(user_id: user_id).first || create!(diary: Bum::Diary.create!)
  end

  def panhandle
    ensure_location
    gonna_die
    calculate_occurrences(__method__.to_sym)
    calculate_earnings
    pass_one_hour
    save!
  end

  def sleep(hours)
    before = energy
    change_energy(hours * 2)
    regulate_metrics
    after = energy
    robbed_in_sleep
    s = hours > 1 ? 's' : ''
    write_in_diary(
      "You slept for #{hours} hour#{s}.",
      energy: (after - before)
    )
    hours.times { pass_one_hour(100, true) }
    save!
  end

  def consume(grocery_id)
    grocery = Grocery.find(grocery_id)
    return unless check_price(grocery.price)
    change_vitals(
      grocery.calories,
      grocery.energy,
      grocery.life,
      (grocery.price * -1)
    )
    write_in_diary(
      "You #{grocery.verb} #{grocery_article(grocery)} #{grocery.name}.",
      money: grocery.price * -1,
      calories: grocery.calories,
      life: grocery.life,
      energy: grocery.energy
    )
    save!
  end

  def rummage
    write_in_diary('You rummaged for an hour.')
    find_cans
    calculate_occurrences(__method__.to_sym)
    find_items
    pass_one_hour(200)
    save!
  end

  private

  def calculate_earnings
    earnings = (
      location.business * location.traffic_by_datetime(time) *
      total_appeal * luck * life_factor
    )
    change_vitals(0, 0, 0, earnings)
    write_in_diary(
      'You panhandled for one hour.',
      money: earnings
    )
  end

  def find_items
    Item.rummageable.each do |item|
      next unless item.rummageable_date <= time
      add_item(item) if rand1000 % item.rummage_chance == 0
    end
  end

  def calculate_occurrences(action)
    Occurrence.each do |occ|
      next unless occ.occur? && occ.send(action)
      apply_occurrence(occ)
    end
  end

  def apply_occurrence(occ)
    return unless occ.available_date <= time
    write_in_diary(
      occ.description,
      calories: occ.calories,
      energy: occ.energy,
      life: occ.life,
      money: occ.money
    )
    change_vitals(occ.calories, occ.energy, occ.life, occ.money)
  end

  def change_vitals(cal = 0, nrg = 0, lif = 0, mon = 0)
    change_calories(cal)
    change_energy(nrg)
    change_life(lif)
    change_money(mon)
    regulate_metrics
  end

  def change_calories(cal)
    return if cal == 0
    self.calories += cal
  end

  def change_energy(nrg)
    return if nrg == 0
    self.energy += nrg
  end

  def change_life(lif)
    return if lif == 0
    self.life += lif
  end

  def change_money(mon)
    return if mon == 0
    self.money += mon
  end

  def find_cans
    cans = rand1000 % 10
    return unless cans > 0
    earnings = cans * 5
    self.money += earnings
    write_in_diary(
      "You found #{cans} cans and cashed them in.",
      money: earnings
    )
  end

  def total_appeal
    item_appeal =
      items.inject(0) do |memo, item_id|
        item = Item.find(item_id)
        memo + item.appeal
      end
    appeal + item_appeal
  end

  def add_item(item)
    return if items.include?(item.id.to_s)
    items << item.id.to_s
    item_name = item.description || item.name
    write_in_diary(
      "You found #{item_name}",
      appeal: item.appeal
    )
  end

  def rand1000
    (1..1000).to_a.sample
  end

  def ensure_location
    self.location = Location.first unless self.location.present?
    save!
  end

  def life_factor
    life >= 300 ? 1 : 0.5
  end

  def regulate_metrics
    self.life = 1000 if life > 1000
    self.energy = 16 if energy > 16
    self.calories = 600 if calories > 600
  end

  def grocery_article(grocery)
    grocery.countable ? 'a' : 'some'
  end

  def gonna_die
    return unless life <= 300
    write_in_diary('You feel like death.')
  end

  def check_price(price)
    result = price <= self.money
    write_in_diary('You don\'t have enough money for that.') unless result
    result
  end

  def format_money(amount)
    string = "$#{(amount / 100.00).round(2)}"
    return string unless string.split('.').last.length == 1
    string + '0'
  end

  def robbed_in_sleep
    return unless rand1000 % 14 == 0
    amount = self.money * 0.4 * luck * -1
    change_money(amount)
    regulate_metrics
    self.total_robbed += amount * -1
    write_in_diary(
      'You got robbed while asleep!  Fuck!',
      money: amount
    )
  end

  def out_of_energy
    return if self.energy >= 0
    self.life -= 20
    self.energy = 0
  end

  def out_of_calories(cal)
    return if self.calories >= 0
    self.life -= cal * 0.2
    self.calories = 0
  end

  def pass_one_hour(cal = 100, sleeping = false)
    self.time += 1.hour
    change_energy(-1) unless sleeping
    sleep_stomach(cal, sleeping)
    out_of_energy
    out_of_calories(cal)
  end

  def sleep_stomach(cal, sleeping)
    cal_start = self.calories
    change_calories(cal * -1)
    change_calories(10) if sleeping && self.calories == 0 && cal_start > 400
  end

  def write_in_diary(text = '', metrics = {})
    return if text.empty?
    diary.save!
    entry = diary.current_entry(self.time)
    entry.add_line_item(text, metrics)
    diary.save!
  end

  def luck
    # random float between 0.70 and 1.30
    (Random.new.rand(60) + 70.0) / 100.0
  end
end
