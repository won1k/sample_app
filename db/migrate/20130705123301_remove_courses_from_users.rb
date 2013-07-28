class RemoveCoursesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :courses
  end
end
