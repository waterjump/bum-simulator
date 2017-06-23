FactoryGirl.define do
  factory :bum do
    money 0
    energy 16
    calories 600
    appeal 10
    time BumSimulator::Application.config.starting_date_time
    items []
  end
end
