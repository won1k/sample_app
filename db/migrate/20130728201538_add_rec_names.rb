class AddRecNames < ActiveRecord::Migration
  def up
  	add_column :users, :rec1name, :string
    add_column :users, :rec2name, :string
  end

end
