namespace :destroy do
  desc 'destoys all bums'
  task bums: :environment do
    Bum.destroy_all
  end
end
