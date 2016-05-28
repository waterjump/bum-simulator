class BumViewModel < ApplicationViewModel
  def day_symbol
    return "\u2600" if model.time.hour >= 6 && model.time.hour <= 19
    "\u263D"
  end

  def date_time
    model.time.strftime('%b %-d, %Y, %l %p')
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
end
