class Bum
  class Action
    def initialize(bum, options = {})
      @bum = bum
    end

    def calculate_occurrences(action)
      Occurrence.each do |occ|
        next unless occ.occur? && occ.send(action)
        apply_occurrence(occ)
      end
    end

    def apply_occurrence(occ)
    return unless occ.available_date <= @bum.time
      write_in_diary(
        occ.description,
        calories: occ.calories,
        energy: occ.energy,
        life: occ.life,
        money: occ.money
      )
      @bum.change_vitals(occ.calories, occ.energy, occ.life, occ.money)
    end

    def pass_one_hour(cal = 100, sleeping = false)
      @bum.time += 1.hour
      @bum.change_energy(-1) unless sleeping
      sleep_stomach(cal, sleeping)
      out_of_energy
      out_of_calories(cal)
    end

    def sleep_stomach(cal, sleeping)
      cal_start = @bum.calories
      @bum.change_calories(cal * -1)
      @bum.change_calories(10) if sleeping && @bum.calories == 0 && cal_start > 400
    end

    def out_of_energy
      return if @bum.energy >= 0
      @bum.life -= 20
      @bum.energy = 0
    end

    def out_of_calories(cal)
      return if @bum.calories >= 0
      @bum.life -= cal * 0.2
      @bum.calories = 0
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
  end
end
