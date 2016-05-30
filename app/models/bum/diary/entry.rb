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
          energy:   (metrics[:energy] || 0),
          calories: (metrics[:calories] || 0),
          life:     (metrics[:life] || 0),
          money:    (metrics[:money] || 0),
          appeal:   (metrics[:appeal] || 0),
          good:     (metrics[:good] || false),
          bad:      (metrics[:bad] || false),
          special:  special?(metrics)
        )
        save!
      end

      def ate_soup?
        line_items.each.inject(false) do |memo, li|
          memo || li.text.include?('soup')
        end
      end

      private

      def special?(metrics)
        return false unless metrics[:chance].present?
        metrics[:chance] >= 10
      end
    end
  end
end
