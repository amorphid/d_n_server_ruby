class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :zone_id
      t.string :name
      t.integer :record_type
      t.integer :record_class
      t.integer :ttl
      t.string :rdata

      t.timestamps
    end
  end
end
