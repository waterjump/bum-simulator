class Sleep < Bum::Action
  def initialize(bum, options = {})
    super
    @action_name = :sleep
    @hours = options[:hours]
  end

  def perform
    before = @bum.energy
    @result.update(energy: @hours * 2)
    after = @bum.energy
    calculate_occurrences(@action_name)
    write_in_diary(
      "You slept for #{@hours} hour#{@hours > 1 ? 's' : ''}.",
      energy: (after - before)
    )
    initial_calories = @bum.calories
    @hours.times { pass_one_hour(100, true) }
    fast(initial_calories)
    @result.apply
  end

  private

  def robbed_in_sleep
    amount = (@bum.money * 0.4 * luck * -1).to_i
    @result.update(money: amount)
    @result.update(total_robbed: amount * -1)
    write_in_diary(
      'You got robbed while asleep!  Fuck!',
      money: amount,
      chance: 14,
      bad: true
    )
  end

  def fast(initial_calories)
    return unless initial_calories >= 400 &&
                  (@bum.calories + @result.calories) <= 0
    offset = initial_calories - 10
    offset = (@result.calories + offset).abs
    @result.update(calories: offset)
  end
end
