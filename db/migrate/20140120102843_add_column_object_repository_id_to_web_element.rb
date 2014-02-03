class AddColumnObjectRepositoryIdToWebElement < ActiveRecord::Migration
  def change
    add_column :web_elements, :object_repository_id, :integer
  end
end
