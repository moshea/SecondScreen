class AlterBroadcasterProgramUuid < ActiveRecord::Migration
  def up
    rename_column :broadcasts, :broadcaster_program_uuid, :broadcaster_program_id
  end

  def down
  end
end
