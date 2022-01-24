class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.date :due_on, null: false
      t.references :user
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
