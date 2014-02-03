class CreateWebElements < ActiveRecord::Migration
  def change
    create_table :web_elements do |t|
      t.string :page_name
      t.string :element_name
      t.string :element_type
      t.string :identifier_name
      t.string :identifier_value

      t.timestamps
    end
  end
end
