class CreateSearchLimiter < ActiveRecord::Migration
  def up
    create_table :search_limiters do |t|
      t.string :broadcast_uuid
      t.datetime :last_external_request
      t.datetime :last_internal_request
      t.integer :search_request_count
      t.timestamps
    end
  end

  def down
  end
end
