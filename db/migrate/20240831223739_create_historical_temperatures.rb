class CreateHistoricalTemperatures < ActiveRecord::Migration[6.1]
  def change
    create_table :historical_temperatures do |t|
      t.decimal :temperature_celsius, precision: 5, scale: 2, null: false
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :historical_temperatures, :recorded_at, unique: true
  end
end
