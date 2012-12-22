class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :broadcast_uuid
      t.string :text
      t.string :user

      t.timestamps
    end
  end
end
