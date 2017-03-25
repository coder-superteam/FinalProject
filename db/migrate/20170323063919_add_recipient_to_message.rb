class AddRecipientToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :recipient_id, :int
  end
end
