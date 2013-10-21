class AddTotalTimeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :time, :integer
  end
end
