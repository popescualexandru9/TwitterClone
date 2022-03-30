class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :handle
      t.text :bio
      t.string :email

      t.timestamps
    end
    
    create_table :tweets do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string :content

      t.timestamps
    end
    
    create_table :likes do |t|
      t.belongs_to :tweet
      t.belongs_to :user

      t.timestamps
    end

  end
end
