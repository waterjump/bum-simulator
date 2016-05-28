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
  field :one_off, type: Boolean, default: false
  field :panhandle, type: Boolean, default: true
  field :rummage, type: Boolean, default: true
  field :sleep, type: Boolean, default: true


  def occur?
    (1..1000).to_a.sample % chance == 0
  end
end
