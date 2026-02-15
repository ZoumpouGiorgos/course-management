class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :code
      t.integer :credits

      t.timestamps
    end
  end
end
