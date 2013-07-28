class AddCoursesToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :courses_old
    add_column :users, :course1, :string
    add_column :users, :course2, :string
    add_column :users, :course3, :string
    add_column :users, :course4, :string
  end
end
