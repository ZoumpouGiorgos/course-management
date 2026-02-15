class DropMessagingTables < ActiveRecord::Migration[7.1]
  def change
    drop_table :conversation_participants, if_exists: true
    drop_table :messages, if_exists: true
    drop_table :conversations, if_exists: true
  end
end
