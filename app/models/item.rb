class Item
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :rummageable, type: Boolean, default: false
  field :rummageable_date,
        type: DateTime,
        default: BumSimulator::Application.config.starting_date_time
  field :rummage_chance, type: Integer, default: 1
  field :price, type: Integer, default: 0
  field :appeal, type: Integer, default: 0

  scope :rummageable, -> { where(rummageable: true) }
end
