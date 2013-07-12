class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :user, index: true
      t.string :appid
      t.string :name
      t.integer :playtime_2weeks
      t.integer :playtime_forever
      t.string :logo

      t.timestamps
    end
  end
end
