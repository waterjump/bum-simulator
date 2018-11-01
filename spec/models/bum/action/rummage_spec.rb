require 'rails_helper'

RSpec.describe Bum::Action::Rummage, type: :model do
  describe '#perform' do
    it 'burns 200 calories an hour' do
      bum = create(:bum)
      no_occurrences
      bum_cal_start = bum.calories

      Bum::Action::Rummage.new(bum).perform

      expect(bum.calories).to eq(bum_cal_start - 200)
    end

    it 'restores some energy when pizza crusts are found' do
      bum = create(:bum)
      force_occurrence('Pizza crust')
      bum_cal_start = bum.calories

      Bum::Action::Rummage.new(bum).perform

      expect(bum.calories).to eq(bum_cal_start - 150)
    end
  end
end
