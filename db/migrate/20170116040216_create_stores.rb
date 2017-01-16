class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :store_location
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :latitude
      t.string :longitude
      t.string :county

      t.timestamps null:false
    end
  end
end
