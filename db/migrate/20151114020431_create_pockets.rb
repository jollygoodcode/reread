class CreatePockets < ActiveRecord::Migration
  def change
    create_table :pockets do |t|
      t.jsonb    :raw, null: false, default: {}
      t.datetime :read_at

      t.references :user, index: true

      t.timestamps
    end
  end
end
