# Be sure to restart your server when you modify this file.
require 'boot_inquirer'

if BootInquirer.assets_required?
  # Remove the assets directory if it exists
  FileUtils.rm_f("#{Rails.root}/assets") if File.exists?("#{Rails.root}/assets")

  # Version of your assets, change this if you want to expire all your assets.
  Rails.application.config.assets.version = '1.0'

  # Add additional assets to the asset load path.
  # Rails.application.config.assets.paths << Emoji.images_path
  # Add Yarn node_modules folder to the asset load path.
  Rails.application.config.assets.paths << Rails.root.join('node_modules')

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in the app/assets
  # folder are already added.
  # Rails.application.config.assets.precompile += %w( admin.js admin.css )

  # make sure the packs directory exists
  # [ :packs, :javascripts, :stylesheets, :images ].each do |dir|
  [ :packs ].each do |dir|
    FileUtils.mkdir_p "#{Rails.root}/assets/#{dir}"

    # link or copy the packs into the root packs directory
    BootInquirer.each_engine_with_assets do |engine|
      # check to make sure the directory exists in the engine
      if File.exists? engine.asset_path

        # iterate through the packs and link/copy them into the root packs dir
        Dir["#{engine.asset_path}/#{dir}/*"].each do |f|
          # if Rails.env.production?
            FileUtils.cp_r f, "#{Rails.root}/assets/#{dir}/"
          # else
          #   FileUtils.ln_sf f, "#{Rails.root}/assets/#{dir}/"
          # end
        end
      end
    end
  end
end