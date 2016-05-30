class Bum
  class Diary
    include Mongoid::Document
    embedded_in :bum, class_name: 'Bum', inverse_of: :diary
    embeds_many :entries,
      class_name: 'Bum::Diary::Entry',
      cascade_callbacks: true

    def current_entry(time)
      entries.where(time: time).first || entries.build(time: time)
    end

    def todays_entries(time)
      entries.select do |entry|
        entry.time.to_date == time.to_date
      end
    end
  end
end
