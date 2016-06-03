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
      chance: 50,
      panhandle: true,
      bad: true,
      life: -100,
      special: true
    )

    Occurrence.create!(
      name: 'Buy teens beer',
      description: 'You bought some beer for some teens that asked you.  They gave you some cash for your help.',
      chance: 69,
      panhandle: true,
      money: 200,
      good: true,
      special: true
    )

    Occurrence.create!(
      name: 'Bible person',
      description: 'Some religious person approached you and was saying some crap about the Bible and Jesus and stuff.  It was of no apparent help.',
      chance: 50,
      panhandle: true,
      one_off: true,
      special: true,
      bad: true
    )

    Occurrence.create!(
      name: 'Robbed in Sleep',
      description: 'You got robbed while asleep!  Fuck!',
      chance: 14,
      sleep: true,
      callback_method: :robbed_in_sleep,
      bad: true,
      special: true
    )

    Occurrence.create!(
      name: 'Pissed yourself',
      description: 'You pissed yourself.',
      chance: 100,
      panhandle: true,
      bad: true,
      special: true
    )

    Occurrence.create!(
      name: 'Entrails Sign',
      description:
        'You looked up and saw a giant billboard that reads'\
        ' "Homeless Entrails Bought and Sold for Cheap!"'\
        '  Fear filled your heart.  My god, how things have'\
        ' changed on the outside.',
      chance: 45,
      one_off: true,
      panhandle: true,
      rummage: true,
      bad: true,
      special: true
    )

    Occurrence.create!(
      name: 'Home Essentials Sign',
      description:
        'You peered back up at the same billboard to see it reads'\
        ' "Home Essentials Bought and Sold for Cheap!"'\
        '  What a relief.  You also pissed yourself.',
      chance: 2,
      one_off: true,
      panhandle: true,
      rummage: true,
      good: true,
      prerequisite: 'Entrails Sign',
      special: true
    )
  end
end
