class CreateTemperatures < ActiveRecord::Migration[6.1]
  def change
    create_table :temperatures do |t|
      t.decimal :temperature_celsius, precision: 5, scale: 2
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :temperatures, :recorded_at, unique: true
  end
end
