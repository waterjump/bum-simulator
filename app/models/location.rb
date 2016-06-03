class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :business, type: Integer, default: 5
  field :traffic, type: Hash, default: {}
  has_many :bums, class_name: 'Bum'

  validates :name, uniqueness: true

  def traffic_by_datetime(date_time)
    day_of_week = traffic.fetch(
      date_time.strftime('%A').downcase,
      traffic['weekday']
    )
    day_of_week[date_time.hour.to_s]
  end
end
