class Grocery
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :price, type: Integer, default: 0
  field :calories, type: Integer, default: 0
  field :energy, type: Integer, default: 0
  field :life, type: Integer, default: 0
  field :countable, type: Boolean, default: true
  field :food, type: Boolean, default: true
  field :verb, type: String
  field :availability,
        type: Hash,
        default: -> { always_available }
  field :available_days,
        type: Array,
        default: -> { every_day }
  field :special_action, type: String
  field :time_spent, type: Integer, default: 0

  def always_available
    (0..23).inject({}) do |memo, hour|
      memo.merge!(hour => true)
    end
  end

  def every_day
    [
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :saturday,
      :sunday
    ]
  end
end
