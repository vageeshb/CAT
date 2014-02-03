class CreateExecutions < ActiveRecord::Migration
  def change
    create_table :executions do |t|
      t.integer :user_id
      t.integer :test_suite_id
      t.integer :test_id
      t.integer :test_step_id
      t.string :status
      t.datetime :last_run

      t.timestamps
    end
  end
end
