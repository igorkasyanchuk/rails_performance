class CreateRailsPerformanceEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :rails_performance_entries do |t|
      t.text :key, null: false
      t.string :key_digest, null: false, limit: 64
      t.string :bucket
      t.text :value, limit: 16.megabytes
      t.datetime :expires_at, null: false

      t.index :key_digest, unique: true
      t.index [:bucket, :expires_at]
      t.index :expires_at
    end
  end
end
