class AddColumnLastRunToTests < ActiveRecord::Migration
  def change
    add_column :tests, :last_run, :DateTime
  end
end
