require 'rails_helper'

RSpec.describe Bum::Action::Sleep, '#perform' do
  it 'restores energy' do
    bum = create(:bum, energy: 2)

    Bum::Action::Sleep.new(bum, hours: 1).perform

    expect(bum.energy).to eq(4)
  end

  it 'passes time' do
    bum = create(:bum, energy: 2)
    starting_time = bum.time

    Bum::Action::Sleep.new(bum, hours: 1).perform

    expect(bum.time).to eq(starting_time + 1.hour)
  end

  it 'enables robbery' do
    bum = create(:bum, energy: 2, money: 1000)
    force_occurrence('Robbed in Sleep')

    Bum::Action::Sleep.new(bum, hours: 1).perform

    expect(bum.money).to be <= 720
    expect(bum.money).to be >= 480
  end

  context 'when bum has a lockbox' do
    it 'is safe from robbery' do
      bum = create(:bum, energy: 2, money: 1000, items: ['lockbox'])
      force_occurrence('Robbed in Sleep')

      Bum::Action::Sleep.new(bum, hours: 1).perform

      expect(bum.money).to eq(1000)
    end
  end
end
