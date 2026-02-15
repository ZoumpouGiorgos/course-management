class RemoveCategoryFromPosts < ActiveRecord::Migration[8.1]
  def change
    remove_column :posts, :category, :string
  end
end
