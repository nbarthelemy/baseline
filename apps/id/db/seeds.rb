puts "############# BEGIN Id Seeds ################"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Id::User.find_or_create_by(email: 'nmb@siquora.com') do |u|
  u.first_name = 'Nick'
  u.last_name = 'Barthelemy'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.skip_confirmation!
end

Dir[File.join(Rails.root, 'apps', '**/id.yml')].each do |config|
  Doorkeeper::Application.find_or_create_by(YAML.load(ERB.new(File.read(config)).result)[Rails.env])
end

puts "############## END Id Seeds #################"
