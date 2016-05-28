class Rummage < Bum::Action

  def initialize(bum, options = {})
    super
    @action_name = :rummage
  end

  def perform
    write_in_diary('You rummaged for an hour.')
    find_cans
    calculate_occurrences(@action_name)
    find_items
    pass_one_hour(200)
    @bum.save!
  end

  def find_cans
    cans = rand1000 % 10
    return unless cans > 0
    earnings = cans * 5
    @bum.money += earnings
    write_in_diary(
      "You found #{cans} cans and cashed them in.",
      money: earnings
    )
  end

  def find_items
    Item.rummageable.each do |item|
      next unless item.rummageable_date <= @bum.time
      add_item(item) if rand1000 % item.rummage_chance == 0
    end
  end

  def add_item(item)
    return if @bum.items.include?(item.id.to_s)
    @bum.items << item.id.to_s
    item_description = item.description || item.name
    write_in_diary(
      "You found #{item_description}",
      appeal: item.appeal
    )
  end
end
