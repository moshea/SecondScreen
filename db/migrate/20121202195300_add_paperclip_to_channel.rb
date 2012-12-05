class AddPaperclipToChannel < ActiveRecord::Migration
  def change
    add_attachment :channels, :logo
  end
end
