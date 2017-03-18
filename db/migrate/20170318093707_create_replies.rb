class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :body

      t.timestamps
    end
  end
end
