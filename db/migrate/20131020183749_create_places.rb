class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
    	t.string :yelp_id
    	t.integer :average
    	t.integer :reviews
      t.timestamps
    end
  end
end
