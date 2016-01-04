class AddAgeMonthsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :age_months, :integer, default: 0
  end
end
