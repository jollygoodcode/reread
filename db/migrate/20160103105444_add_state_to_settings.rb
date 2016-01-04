class AddStateToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :state, :string, default: 'unread'
  end
end
