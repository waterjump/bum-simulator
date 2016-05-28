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
    robbed_in_sleep
    s = @hours > 1 ? 's' : ''
    write_in_diary(
      "You slept for #{@hours} hour#{s}.",
      energy: (after - before)
    )
    @hours.times { pass_one_hour(100, true) }
    @result.apply
  end

  def robbed_in_sleep
    return unless rand1000 % 14 == 0
    amount = @bum.money * 0.4 * luck * -1
    @result.update(money: amount)
    @result.update(total_robbed: amount * -1)
    write_in_diary(
      'You got robbed while asleep!  Fuck!',
      money: amount
    )
  end
end
