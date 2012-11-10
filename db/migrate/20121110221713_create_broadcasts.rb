class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.integer :channel_id
      t.string :broadcaster_broadcast_id
      t.date :start
      t.date :end
      t.string :broadcaster_program_uuid
      t.text :synopsis
      t.string :title
      t.string :subtitle
      t.string :uuid

      t.timestamps
    end
  end
end
