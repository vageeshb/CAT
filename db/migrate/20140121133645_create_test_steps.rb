class CreateTestSteps < ActiveRecord::Migration
  def change
    create_table :test_steps do |t|
      t.string :step_name
      t.text :step_description
      t.string :expected
      t.integer :object_repository_id
      t.string :page_name
      t.integer :element_id
      t.string :function
      t.string :value
      t.integer :test_id

      t.timestamps
    end
  end
end
