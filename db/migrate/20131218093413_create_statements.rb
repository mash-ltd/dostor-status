class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.string  :body, null: false
      t.integer :number, null: false

      t.timestamps
    end
  end
end
