class Bum
  class Action
    def initialize(bum, _options = {}, *args)
      @bum = bum
      @result = Bum::Action::Result.new(bum)
    end

    def calculate_occurrences(action, force_name = nil)
      Occurrence.each do |occ|
        next unless occ.occur?(@bum.time, force_name) &&
                    occ.send(action) &&
                    !seen_one_off?(occ) &&
                    prerequisite_present?(occ)
        apply_occurrence(occ)
      end
    end

    def apply_occurrence(occ)
      occ_hash = {
        calories: occ.calories,
        energy: occ.energy,
        life: occ.life,
        money: occ.money,
        special: occ.special,
        good: occ.good,
        bad: occ.bad
      }
      occ_hash[:occurrences] = occ.name if occ.one_off?
      send(occ.callback_method) if occ.callback_method.present?
      write_in_diary(occ.description, occ_hash) if occ.callback_method.nil?
      @result.update(occ_hash)
    end

    def pass_one_hour(cal = 100, sleeping = false)
      @result.update(time: 1.hour)
      @result.update(energy: -1) unless sleeping
      @result.update(calories: (cal * -1))
    end

    def write_in_diary(text = '', metrics = {})
      return if text.empty?
      @bum.diary.save!
      entry = @bum.diary.current_entry(@bum.time)
      entry.add_line_item(text, metrics)
      @bum.diary.save!
    end

    def luck
      # random float between 0.70 and 1.30
      (Random.new.rand(60) + 70.0) / 100.0
    end

    def rand1000
      (1..1000).to_a.sample
    end

    private

    def seen_one_off?(occ)
      occ.one_off? && @bum.occurrences.include?(occ.name)
    end

    def prerequisite_present?(occ)
      return true unless occ.prerequisite.present?
      @bum.occurrences.include?(occ.prerequisite)
    end
  end
end
