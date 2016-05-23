namespace :seed do
  desc 'add food items'
  task food: :environment do
    Food.create!(name: 'Pretzel', price: 50, calories: 145)
  end
end
