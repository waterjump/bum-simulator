class Food
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :price, type: Integer
  field :calories, type: Integer
end
