class AddArticleToStatements < ActiveRecord::Migration
  def change
   add_column :statements, :article, :integer, default: 0
  end
end
