class Occurrence
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :chance, type: Integer, default: 1000
  field :available_date,
        type:    DateTime,
        default: BumSimulator::Application.config.starting_date_time
  field :energy, type: Integer, default: 0
  field :calories, type: Integer, default: 0
  field :life, type: Integer, default: 0
  field :money, type: Integer, default: 0
  field :one_off, type: Boolean, default: false
  field :panhandle, type: Boolean, default: false
  field :rummage, type: Boolean, default: false
  field :sleep, type: Boolean, default: false
  field :good, type: Boolean, default: false
  field :bad, type: Boolean, default: false
  field :callback_method, type: Symbol
  field :prerequisite, type: String
  field :special, type: Boolean, default: false
  field :force, type: Boolean, default: false
  field :suppress, type: Boolean, default: false

  def occur?(time)
    available?(time) && (1..1000).to_a.sample % chance == 0
  end

  def available?(time)
    available_date <= time
  end
end
