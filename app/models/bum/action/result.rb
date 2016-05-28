class Bum
  class Action
    class Result
      def initialize(bum, metrics = {})
        @bum = bum
        @energy = metrics[:energy] || 0
        @calories = metrics[:calories] || 0
        @life = metrics[:life] || 0
        @money = metrics[:money] || 0
        @appeal = metrics[:appeal] || 0
        @time = metrics[:time] || 0.hours
        @items = metrics[:items] || []
        @total_robbed = metrics[:total_robbed] || 0
      end

      def update(metrics = {})
        @energy += metrics[:energy] || 0
        @calories += metrics[:calories] || 0
        @life += metrics[:life] || 0
        @money += metrics[:money] || 0
        @appeal += metrics[:appeal] || 0
        @time += metrics[:time] || 0.hours
        @items << metrics[:items] if metrics[:items].present?
        @total_robbed += metrics[:total_robbed] || 0
      end

      def apply
        regulate_vitals
        @bum.inc(energy: @energy) if @energy != 0
        @bum.inc(calories: @calories) if @calories != 0
        @bum.inc(life: @life) if @life != 0
        @bum.inc(money: @money) if @money != 0
        @bum.inc(appeal: @appeal) if @appeal != 0
        @bum.inc(total_robbed: @total_robbed) if @total_robbed != 0
        @bum.items += (@items - @bum.items)
        @bum.update_attribute(:time, @bum.time + @time) if @time != 0.hours
        @bum.save!
      end

      private

      def regulate_vitals
        out_of_energy
        energy_full
        out_of_calories
        calories_full
        life_full
      end

      def out_of_energy
        return unless @bum.energy + @energy < 0
        @life += -20
        @energy = @bum.energy * -1
      end

      def energy_full
        return unless @bum.energy + @energy > 16
        @energy = 16 - @bum.energy
      end

      def out_of_calories
        deficit = @bum.calories + @calories
        return unless deficit < 0
        @life += deficit * 0.2
        @calories = @bum.calories * -1
      end

      def calories_full
        return unless @bum.calories + @calories > 600
        @calories = 600 - @bum.calories
      end

      def life_full
        return unless @bum.life > 1600
        @life = 1600 - @bum.life
      end
    end
  end
end
