class Bum
  class Diary
    class Entry
      class LineItem
        include Mongoid::Document
        embedded_in :entry, class_name: 'Bum::Diary::Entry', inverse_of: :line_items

        field :text, type: String
        field :energy, type: Integer
        field :calories, type: Integer
        field :life, type: Integer
        field :money, type: Integer
        field :appeal, type: Integer
      end
    end
  end
end
