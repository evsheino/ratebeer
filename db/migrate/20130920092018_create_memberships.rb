class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :beer_club_id

      t.timestamps
    end

    add_index :memberships, [:user_id, :beer_club_id], unique: true
  end
end
