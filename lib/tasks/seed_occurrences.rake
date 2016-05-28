namespace :seed do
  desc 'add items'
  task occurrences: :environment do
    Occurrence.destroy_all

    Occurrence.create!(
      name: 'slim jim',
      description: 'Some kid gave you a slim jim.',
      calories: 100,
      chance: 24,
      rummage: false,
      sleep: false,
      panhandle: true
    )

    Occurrence.create!(
      name: 'Pizza crust',
      description: 'You found some pizza crust in a dumpster and ate it.',
      calories: 50,
      chance: 3,
      rummage: true,
      sleep: false,
      panhandle: false
    )
  end
end
