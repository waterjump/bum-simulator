namespace :seed do
  desc 'add locations'
  task locations: :environment do
    Location.destroy_all

    Location.create!(
      name: 'Front and Girard',
      business: 5,
      traffic:
        {
          weekday:
            {
              0 => 0.4,
              1 => 0.3,
              2 => 0.2,
              3 => 0.2,
              4 => 0.2,
              5 => 0.2,
              6 => 0.4,
              7 => 1.2,
              8 => 1.2,
              9 => 1.0,
              10 => 1.0,
              11 => 1.0,
              12 => 1.2,
              13 => 1.1,
              14 => 1.0,
              15 => 1.0,
              16 => 1.0,
              17 => 1.2,
              18 => 1.2,
              19 => 1.0,
              20 => 0.85,
              21 => 0.7,
              22 => 0.6,
              23 => 0.5
            },
          friday:
            {
              0 => 0.4,
              1 => 0.3,
              2 => 0.2,
              3 => 0.2,
              4 => 0.2,
              5 => 0.2,
              6 => 0.4,
              7 => 1.2,
              8 => 1.2,
              9 => 1.0,
              10 => 1.0,
              11 => 1.0,
              12 => 1.2,
              13 => 1.1,
              14 => 1.0,
              15 => 1.0,
              16 => 1.0,
              17 => 1.2,
              18 => 1.2,
              19 => 1.0,
              20 => 1.0,
              21 => 1.0,
              22 => 1.0,
              23 => 1.0
            },
          saturday:
            {
              0 => 1.0,
              1 => 1.2,
              2 => 1.5,
              3 => 0.2,
              4 => 0.2,
              5 => 0.2,
              6 => 0.4,
              7 => 0.6,
              8 => 0.6,
              9 => 0.6,
              10 => 0.7,
              11 => 0.7,
              12 => 0.7,
              13 => 0.7,
              14 => 0.7,
              15 => 0.8,
              16 => 0.8,
              17 => 0.9,
              18 => 1.2,
              19 => 1.0,
              20 => 1.0,
              21 => 1.2,
              22 => 1.2,
              23 => 1.1
            },
          sunday: {
            0 => 1.0,
            1 => 1.2,
            2 => 1.5,
            3 => 0.2,
            4 => 0.2,
            5 => 0.2,
            6 => 0.3,
            7 => 0.3,
            8 => 0.3,
            9 => 0.3,
            10 => 0.4,
            11 => 0.4,
            12 => 0.4,
            13 => 0.4,
            14 => 0.4,
            15 => 0.4,
            16 => 0.4,
            17 => 0.4,
            18 => 0.3,
            19 => 0.3,
            20 => 0.3,
            21 => 0.3,
            22 => 0.3,
            23 => 0.3
          }
        }
    )
  end
end
