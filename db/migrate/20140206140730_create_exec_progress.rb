class CreateExecProgress < ActiveRecord::Migration
  def change
    create_table :exec_progress do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :test_step_id

      t.timestamps
    end
  end
end
