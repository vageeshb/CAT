class CreateExecProgresses < ActiveRecord::Migration
  def change
    create_table :exec_progresses do |t|
      t.integer :user_id
      t.integer :test_id
      t.integer :test_step_id
      t.string :status

      t.timestamps
    end
  end
end
