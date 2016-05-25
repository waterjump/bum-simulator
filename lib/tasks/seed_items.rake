namespace :seed do
  desc 'add items'
  task items: :environment do
    Item.create!(
      name: 'Phillies hat',
      description: 'a Phillies hat',
      rummageable: true,
      rummage_chance: 15,
      appeal: 2,
    )

    Item.create!(
      name: 'Cardboard sign',
      description: 'a cardboard sign that has "Homles and hungrie Dog Bless scrawled on it.',
      rummageable: true,
      rummage_chance: 2,
      appeal: 1,
    )
  end
end
