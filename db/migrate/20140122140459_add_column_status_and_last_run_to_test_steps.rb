class AddColumnStatusAndLastRunToTestSteps < ActiveRecord::Migration
  def change
    add_column :test_steps, :status, :string
    add_column :test_steps, :last_run, :DateTime
  end
end
