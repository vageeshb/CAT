class CreateSeleniumConfigs < ActiveRecord::Migration
  def change
    create_table :selenium_configs do |t|
      t.string :browser
      t.string :url
      t.integer :user_id

      t.timestamps
    end
  end
end
