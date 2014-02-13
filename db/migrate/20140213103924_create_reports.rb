class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :user_id
      t.integer :test_suite_id
      t.integer :test_id
      t.integer :test_step_id
      t.string :status

      t.timestamps
    end
  end
end
