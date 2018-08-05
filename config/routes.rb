require 'boot_inquirer'

Rails.application.routes.draw do

  use_doorkeeper
  BootInquirer.enabled(:apps).each do |app|
    mount app.engine => '/', as: app.name
  end

end