# frozen_string_literal: true

class CreateFriend < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|
      t.belongs_to :follower, foreign_key: { to_table: :users }, null: false, index: true
      t.belongs_to :following, foreign_key: { to_table: :users }, null: false, index: true

      t.timestamps
    end
  end
end
