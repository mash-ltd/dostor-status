class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.integer :facebook_id, limit: 8, null:false
      t.string :access_token
    end
  end
end
