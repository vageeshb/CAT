class AddColumnUserIdToObjectRepositories < ActiveRecord::Migration
  def change
    add_column :object_repositories, :user_id, :integer
  end
end
