class AddColumnStatusToExecProgress < ActiveRecord::Migration
  def change
    add_column :exec_progress, :status, :string
  end
end
