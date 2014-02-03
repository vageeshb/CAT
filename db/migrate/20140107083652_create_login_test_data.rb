class CreateLoginTestData < ActiveRecord::Migration
  def change
    create_table :login_test_data do |t|
      t.string :email
      t.string :password
      t.boolean :check

      t.timestamps
    end
  end
end
