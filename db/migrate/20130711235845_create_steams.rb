class CreateSteams < ActiveRecord::Migration
  def change
    create_table :steams do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
