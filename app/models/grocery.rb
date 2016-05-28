class Grocery
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :price, type: Integer
  field :calories, type: Integer
  field :energy, type: Integer
  field :life, type: Integer
  field :countable, type: Boolean, default: true
  field :food, type: Boolean, default: true
  field :verb, type: String
  field :availability,
        type: Hash,
        default: -> { always_available }

  def always_available
    (0..23).inject({}) do |memo, hour|
      memo.merge!(hour => true)
    end
  end
end
