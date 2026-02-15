class RecreateMessagingTables < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.string :title
      t.timestamps
    end

    create_table :conversation_participants do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :conversation_participants,
              [:conversation_id, :user_id],
              unique: true,
              name: "index_conversation_participants_on_conversation_and_user"

    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end

    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :actor, null: true, foreign_key: { to_table: :users }

      t.references :notifiable, polymorphic: true, null: true

      t.string :action, null: false
      t.datetime :read_at
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :notifications, :read_at
    add_index :notifications, [:recipient_id, :read_at]
  end
end
