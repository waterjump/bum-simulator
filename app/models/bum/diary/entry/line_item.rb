class Bum
  class Diary
    class Entry
      class LineItem
        include Mongoid::Document
        embedded_in :entry,
                    class_name: 'Bum::Diary::Entry',
                    inverse_of: :line_items

        field :text, type: String
        field :energy, type: Integer
        field :calories, type: Integer
        field :life, type: Integer
        field :money, type: Integer
        field :appeal, type: Integer
        field :special, type: Boolean, default: false
        field :good, type: Boolean, default: false
        field :bad, type: Boolean, default: false

        scope :special_good, -> { where(special: true, good: true) }
        scope :special_bad, -> { where(special: true, bad: true) }
        scope :normal, -> { where(special: false) }
      end
    end
  end
end
