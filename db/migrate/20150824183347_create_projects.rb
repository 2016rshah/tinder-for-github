class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :username
      t.string :title

      t.timestamps null: false
    end
  end
end
