class AddRedirectToToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :redirect_to, :string, default: :given_url
  end
end
