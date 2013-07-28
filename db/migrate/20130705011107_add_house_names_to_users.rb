class AddHouseNamesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :house, :string, default: nil
  end
end
