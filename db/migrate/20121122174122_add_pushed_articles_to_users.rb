class AddPushedArticlesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pushed_articles, :integer, default: 0
  end
end
