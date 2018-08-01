# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Basic attributes
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, default: ""
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end