namespace :seed do
  desc 'add food items'
  task groceries: :environment do
    Grocery.destroy_all

    Grocery.create!(
      name: 'pretzel',
      price: 50,
      calories: 145,
      energy: 0,
      life: 0,
      countable: true,
      food: true,
      verb: 'eat'
    )

    Grocery.create!(
      name: '40',
      price: 400,
      calories: 0,
      energy: 0,
      life: 200,
      countable: true,
      food: false,
      verb: 'drink',
      availability: {
        0 => true,
        1 => true,
        2 => false,
        3 => false,
        4 => false,
        5 => false,
        6 => false,
        7 => false,
        8 => false,
        9 => false,
        10 => true,
        11 => true,
        12 => true,
        13 => true,
        14 => true,
        15 => true,
        16 => true,
        17 => true,
        18 => true,
        19 => true,
        20 => true,
        21 => true,
        22 => true,
        23 => true
      }
    )

    Grocery.create!(
      name: 'cheeseburger',
      price: 200,
      calories: 600,
      energy: 0,
      life: 0,
      countable: true,
      food: true,
      verb: 'eat'
    )

    Grocery.create!(
      name: 'energy drink',
      price: 150,
      calories: 100,
      energy: 2,
      life: 0,
      countable: true,
      food: false,
      verb: 'drink'
    )

    Grocery.create!(
      name: 'soup',
      price: 0,
      calories: 800,
      life: 100,
      time_spent: 1,
      countable: false,
      food: true,
      verb: 'eat',
      availability: {
        0 =>  false,
        1 => false,
        2 => false,
        3 => false,
        4 => false,
        5 => false,
        6 => false,
        7 => false,
        8 => false,
        9 => false,
        10 => true,
        11 => true,
        12 => true,
        13 => true,
        14 => true,
        15 => true,
        16 => true,
        17 => true,
        18 => true,
        19 => true,
        20 => false,
        21 => false,
        22 => false,
        23 => false
      },
      available_days: [:sunday],
      special_action: 'Go to the soup kitchen'
    )
  end
end
