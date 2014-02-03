class AddColumnTestStepIdToTests < ActiveRecord::Migration
  def change
    add_column :tests, :test_step_id, :integer
  end
end
