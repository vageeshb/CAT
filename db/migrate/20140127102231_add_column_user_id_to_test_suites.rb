class AddColumnUserIdToTestSuites < ActiveRecord::Migration
  def change
    add_column :test_suites, :user_id, :integer
  end
end
