puts "############# BEGIN Core Seeds ################"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Core::User.find_or_create_by(email: 'nmb@siquora.com') do |u|
  u.first_name = 'Nick'
  u.last_name = 'Barthelemy'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.skip_confirmation!
end

puts "############## END Core Seeds #################"
