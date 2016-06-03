class Bum
  class Action
    class Result
      attr_reader :calories
      def initialize(bum, metrics = {})
        @bum = bum
        @energy = metrics.fetch(:energy, 0)
        @calories = metrics.fetch(:calories, 0)
        @life = metrics.fetch(:life, 0)
        @money = metrics.fetch(:money, 0)
        @appeal = metrics.fetch(:appeal, 0)
        @time = metrics.fetch(:time, 0.hours)
        @items = metrics.fetch(:items, [])
        @occurrences = metrics.fetch(:occurrences, [])
      end

      def update(metrics = {})
        metrics.slice(*valid_keys).each do |field, value|
          instance_variable_set(
            "@#{field}",
            instance_variable_get("@#{field}".to_sym) + value
          )
        end
        @items << metrics[:items] if metrics[:items].present?
        @occurrences << metrics[:occurrences] if metrics[:occurrences].present?
      end

      def apply
        regulate_vitals
        increment(
          energy:     @energy,
          calories:   @calories,
          life:       @life,
          money:      @money,
          appeal:     @appeal
        )
        @bum.items += (@items - @bum.items)
        @bum.occurrences += @occurrences
        @bum.update_attribute(:time, @bum.time + @time) if @time > 0.hours
        @bum.save!
      end

      private

      def valid_keys
        [
          :energy,
          :calories,
          :life,
          :money,
          :appeal,
          :time
        ]
      end

      def increment(hash)
        hash.each do |field, value|
          next if value == 0
          @bum.inc(field => value)
        end
      end

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
        return unless @bum.life + @life > 1000
        @life = 1000 - @bum.life
      end
    end
  end
end
