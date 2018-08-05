require 'boot_inquirer'

Rails.application.routes.draw do

  BootInquirer.enabled(:apps).each do |app|
    mount app.engine => '/', as: app.name
  end

end