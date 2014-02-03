class CreateObjectRepositories < ActiveRecord::Migration
  def change
    create_table :object_repositories do |t|
      t.string :name
      t.text :description
      t.string :url
      t.text :attachments
    end
  end
end
