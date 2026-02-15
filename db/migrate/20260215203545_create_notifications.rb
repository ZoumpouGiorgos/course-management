class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: true, foreign_key: { to_table: :users }

      t.references :notifiable, polymorphic: true, null: true

      t.string :action, null: false
      t.datetime :read_at
      t.text :metadata, null: false, default: "{}"

      t.timestamps
    end

    add_index :notifications, :read_at
    add_index :notifications, [:recipient_id, :read_at]
  end
end
