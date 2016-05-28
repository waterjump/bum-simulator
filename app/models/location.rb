class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :business, type: Integer, default: 5
  field :traffic, type: Hash, default: {}
  has_many :bums, class_name: 'Bum'

  validates :name, uniqueness: true

  def traffic_by_datetime(date_time)
    hour = date_time.hour.to_s
    return traffic['friday'][hour] if date_time.friday?
    return traffic['saturday'][hour] if date_time.saturday?
    return traffic['sunday'][hour] if date_time.sunday?
    traffic['weekday'][hour]
  end
end
