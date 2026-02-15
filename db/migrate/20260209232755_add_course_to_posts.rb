class AddCourseToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :course, null: false, foreign_key: true
  end
end
