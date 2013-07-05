class ChangeAdminToInt < ActiveRecord::Migration
  def up
  	change_table :users do |user|
  		user.change :admin, :integer
  	end
  end

  def down
  	change_table :users do |user|
  		user.change :admin, :boolean
  	end
  end
end
