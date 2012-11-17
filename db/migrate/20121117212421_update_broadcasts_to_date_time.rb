class UpdateBroadcastsToDateTime < ActiveRecord::Migration
  def up
    change_column :broadcasts, :start, :datetime
    change_column :broadcasts, :end, :datetime
  end

  def down
  end
end
