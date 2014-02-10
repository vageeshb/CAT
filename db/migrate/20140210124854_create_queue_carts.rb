class CreateQueueCarts < ActiveRecord::Migration
  def change
    create_table :queue_carts do |t|
      t.integer :test_suite_id
      t.integer :test_id
      t.integer :test_step_id

      t.timestamps
    end
  end
end
