namespace :seed do
  desc 'add items'
  task items: :environment do
    Item.destroy_all

    Item.create!(
      name: 'Phillies hat',
      description: 'a Phillies hat',
      rummageable: true,
      rummage_chance: 15,
      appeal: 2,
    )

    Item.create!(
      name: 'Cardboard sign',
      description: 'a cardboard sign that has "Homless and hungrie - Dog Bless U" scrawled on it.',
      rummageable: true,
      rummage_chance: 2,
      appeal: 1,
    )

    Item.create!(
      name: 'Schizophrenia book',
      description: 'a book called "Schizophrenia and You: A Beginner\'s Guide to Controlling your Paranoid Ramblings"',
      rummageable: true,
      rummage_chance: 30,
      appeal: 1,
    )

    Item.create!(
      name: 'Wheelchair',
      description: 'a rusty wheelchair',
      rummageable: true,
      rummage_chance: 666,
      appeal: 10,
    )

    Item.create!(
      id: 'lockbox',
      name: 'Lockbox',
      description: 'a metal lockbox to keep from getting robbed while asleep.',
      purchaseable: true,
      appeal: 0,
      price: 2000
    )
  end
end
