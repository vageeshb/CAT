class AddColumnStatusToReport < ActiveRecord::Migration
  def change
    add_column :reports, :status, :string
  end
end
