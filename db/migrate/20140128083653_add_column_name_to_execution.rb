class AddColumnNameToExecution < ActiveRecord::Migration
  def change
    add_column :executions, :name, :string
  end
end
