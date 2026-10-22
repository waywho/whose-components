# frozen_string_literal: true

class AddNamesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string
    add_column :users, :name, :string, null: false
    add_column :users, :nickname, :string
  end
end
