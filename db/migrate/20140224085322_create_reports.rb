class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :job_id
      t.integer :user_id
      t.string :description

      t.timestamps
    end
  end
end
