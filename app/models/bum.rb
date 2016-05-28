class Bum
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: String
  field :money, type: Integer, default: 0
  field :energy, type: Integer, default: 16
  field :calories, type: Integer, default: 600
  field :appeal, type: Integer, default: 10
  field :diary, type: Hash, default: {}
  field :time,
        type:    DateTime,
        default: BumSimulator::Application.config.starting_date_time
  field :life, type: Integer, default: 1000
  field :total_panhandled, type: Integer, default: 0
  field :total_robbed, type: Integer, default: 0
  field :items, type: Array, default: []
  embeds_one :diary,
             class_name: 'Bum::Diary',
             cascade_callbacks: true
  belongs_to :location, class_name: 'Location'

  def self.find_or_initialize(user_id)
    where(user_id: user_id).first || create!(diary: Bum::Diary.create!)
  end

  def total_appeal
    item_appeal =
      items.inject(0) do |memo, item_id|
        item = Item.find(item_id)
        memo + item.appeal
      end
    appeal + item_appeal
  end

  def life_factor
    life >= 300 ? 1 : 0.5
  end
end
