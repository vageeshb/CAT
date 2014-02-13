class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :user_id
      t.integer :test_suite_id
      t.integer :test_id
      t.integer :test_step_id
      t.string :status
      t.datetime :start_time
      t.string :finish_time

      t.timestamps
    end
  end
end
