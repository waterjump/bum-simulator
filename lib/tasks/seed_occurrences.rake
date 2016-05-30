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
      panhandle: true,
      good: true
    )

    Occurrence.create!(
      name: 'Pizza crust',
      description: 'You found some pizza crust in a dumpster and ate it.',
      calories: 50,
      chance: 3,
      rummage: true,
      sleep: false,
      panhandle: false,
      good: true
    )

    Occurrence.create!(
      name: 'Buy teens beer',
      description: 'You bought some beer for some teens that asked you.  They gave you some cash for your help.',
      chance: 50,
      rummage: false,
      sleep: false,
      panhandle: true,
      money: 200,
      good: true
    )

    Occurrence.create!(
      name: 'Bible person',
      description: 'Some relogious person approached you and was saying some crap about the Bible and Jesus and stuff.  It was of no apparent help.',
      chance: 50,
      rummage: false,
      sleep: false,
      panhandle: true,
    )
  end
end
