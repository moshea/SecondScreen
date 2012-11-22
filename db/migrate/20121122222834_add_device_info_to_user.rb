class AddDeviceInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :device_id, :string
    add_column :users, :os_version, :string
    add_column :users, :api_level, :integer
    add_column :users, :make, :string
    add_column :users, :model, :string
  end
end
