class BumViewModel < ApplicationViewModel
  def day_symbol
    return "\u2600" if model.time.hour >= 6 && model.time.hour <= 19
    "\u263D"
  end

  def date_time
    model.time.strftime('%A %b %-d, %Y, %l %p')
  end

  def energy_fill
    (model.energy / 16.0 ) * 250
  end

  def hunger_fill
    (model.calories / 600.0 ) * 250
  end

  def life_fill
    (model.life / 1000.0 ) * 250
  end

  def line_mark(metric)
    return ' + ' if metric > 0
    ' - '
  end

  def item_names
    model.items.map { |i| Item.find(i).name.titleize }
  end

  def total_appeal
    item_appeal =
      model.items.inject(0) do |memo, item_id|
        item = Item.find(item_id)
        memo + item.appeal
      end
    appeal + item_appeal
  end
end
