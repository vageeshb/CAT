class AddColumnTestSuiteIdToTests < ActiveRecord::Migration
  def change
    add_column :tests, :test_suite_id, :int
  end
end
