class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string  :email
      t.string  :time_zone
      t.string  :send_at
      t.string  :schedule
      t.integer :number   , default: 1
      t.boolean :pause    , default: false

      t.references :user, index: true

      t.timestamps
    end
  end
end
