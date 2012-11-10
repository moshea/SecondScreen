class AddBroadcasterId < ActiveRecord::Migration
  def up
    change_table :channels do |t|
      t.integer :broadcaster_id
    end
  end

  def down
  end
end
