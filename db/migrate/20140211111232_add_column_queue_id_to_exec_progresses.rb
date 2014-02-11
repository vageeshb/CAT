class AddColumnQueueIdToExecProgresses < ActiveRecord::Migration
  def change
    add_column :exec_progresses, :queue_id, :integer
  end
end
