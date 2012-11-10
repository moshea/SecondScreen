class CreateBroadcasters < ActiveRecord::Migration
  def change
    create_table :broadcasters do |t|
      t.string :name
      t.string :logo_url

      t.timestamps
    end
  end
end
