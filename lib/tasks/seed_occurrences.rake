namespace :seed do
  desc 'add items'
  task occurrences: :environment do
    Occurrence.destroy_all

    Occurrence.create!(
      name: 'slim jim',
      description: 'Some kid gave you a slim jim.',
      calories: 100,
      chance: 24,
      panhandle: true,
      good: true
    )

    Occurrence.create!(
      name: 'Pizza crust',
      description: 'You found some pizza crust in a dumpster and ate it.',
      calories: 50,
      chance: 3,
      rummage: true,
      good: true
    )

    Occurrence.create!(
      name: 'Frat kick',
      description: 'Some frat boy douche bag just randomly ran up and kicked you.',
      calories: 0,
      chance: 50,
      panhandle: true,
      bad: true,
      life: -100
    )

    Occurrence.create!(
      name: 'Buy teens beer',
      description: 'You bought some beer for some teens that asked you.  They gave you some cash for your help.',
      chance: 69,
      panhandle: true,
      money: 200,
      good: true
    )

    Occurrence.create!(
      name: 'Bible person',
      description: 'Some relogious person approached you and was saying some crap about the Bible and Jesus and stuff.  It was of no apparent help.',
      chance: 50,
      panhandle: true
    )

    Occurrence.create!(
      name: 'Robbed in Sleep',
      description: 'You got robbed while asleep!  Fuck!',
      chance: 14,
      sleep: true,
      custom_method: :robbed_in_sleep
    )
  end
end
