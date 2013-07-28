class AddIdCoursesDormPhoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :national_id, :integer, default: nil
  	add_column :users, :courses, :string, default: nil
  	add_column :users, :dorm, :string, default: nil
  	add_column :users, :phone, :integer, default: nil
  end
end
