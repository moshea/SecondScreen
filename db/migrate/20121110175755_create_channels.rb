class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :logo_url
      t.string :ingestion_url
      t.string :ingestion_module

      t.timestamps
    end
  end
end
