class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string  :body, null: false
      t.integer :number, null: false

      t.timestamps
    end
  end
end
