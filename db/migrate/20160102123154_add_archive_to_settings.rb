class AddArchiveToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :archive, :boolean, default: false
  end
end
