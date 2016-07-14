class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender, limit: 1
      t.float :latitude
      t.float :longitude
      t.integer :infection_count, default: 0

      t.timestamps
    end
  end
end
