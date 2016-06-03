class Bum
  class Diary
    class Entry
      include Mongoid::Document
      embedded_in :diary, class_name: 'Bum::Diary', inverse_of: :entries
      embeds_many :line_items,
                  class_name: 'Bum::Diary::Entry::LineItem',
                  cascade_callbacks: true

      field :time, type: DateTime

      validates :time, presence: true

      def self.find_or_initialize(time)
        where(time: time).first || create!(time: time)
      end

      def add_line_item(text, metrics = {})
        line_items.build(
          text:     text,
          energy:   metrics.fetch(:energy, 0),
          calories: metrics.fetch(:calories, 0),
          life:     metrics.fetch(:life, 0),
          money:    metrics.fetch(:money, 0),
          appeal:   metrics.fetch(:appeal, 0),
          good:     metrics.fetch(:good, false),
          bad:      metrics.fetch(:bad, false),
          special:  metrics.fetch(:chance, 1) >= 10
        )
        save!
      end

      def ate_soup?
        line_items.each.inject(false) do |memo, li|
          memo || li.text.include?('soup')
        end
      end
    end
  end
end
