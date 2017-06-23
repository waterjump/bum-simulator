class Panhandle < Bum::Action
  def initialize(bum, options = {})
    super
    @action_name = :panhandle
  end

  def perform
    calculate_occurrences(@action_name)
    calculate_earnings
    pass_one_hour
    @result.apply
  end

  private

  def calculate_earnings
    earnings = (
      location.business *
      location.traffic_by_datetime(@bum.time) *
      @bum.total_appeal *
      luck *
      @bum.life_factor
    ).to_i
    @result.update(money: earnings) if earnings > 0
    write_in_diary(
      'You panhandled for one hour.', money: earnings
    )
  end

  def location
    return @bum.location if @bum.location.present?
    @bum.location = Location.first
    @bum.save!
    @bum.location
  end
end
