class DropSearchLimiter < ActiveRecord::Migration
  def up
    drop_table :search_limiters
  end

  def down
  end
end
