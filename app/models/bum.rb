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
    where(user_id: user_id).first ||
    create!(
      user_id: user_id.presence,
      diary: Bum::Diary.create!
    )
  end

  def life_factor
    life >= 300 ? 1 : 0.5
  end

  def ate_soup_today?
    return false unless todays_entries.present?
    todays_entries.inject(false) do |memo, entry|
      memo || entry.ate_soup?
    end
  end

  private

  def todays_entries
    diary.todays_entries(time)
  end
end
