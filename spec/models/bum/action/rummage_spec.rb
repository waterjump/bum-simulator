require 'rails_helper'

RSpec.describe Bum::Action::Rummage, '#perform' do
  it 'burns 200 calories an hour' do
    bum = BumViewModel.wrap(create(:bum))
    bum_cal_start = bum.calories
    Bum::Action::Rummage.new(bum).perform(no_items: true, no_occ: true)
    expect(bum.calories).to eq(bum_cal_start - 200)
  end

  it 'restores some energy when pizza crusts are found' do
    bum = BumViewModel.wrap(create(:bum))
    bum_cal_start = bum.calories
    Bum::Action::Rummage.new(bum).perform(force_occ: 'Pizza crust', no_items: true)
    expect(bum.calories).to eq(bum_cal_start - 150)
  end
end
