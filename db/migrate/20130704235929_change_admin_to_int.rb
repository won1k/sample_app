class ChangeAdminToInt < ActiveRecord::Migration
  def up
  	rename_column :users, :admin, :admin_boolean
    add_column :users, :admin, :integer

    User.reset_column_information
    User.find_each { |user| user.update_attribute(:admin, user.admin_boolean) }
    remove_column :users, :admin_boolean
  end
end
