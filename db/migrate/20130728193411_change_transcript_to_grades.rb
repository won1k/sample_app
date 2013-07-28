class ChangeTranscriptToGrades < ActiveRecord::Migration
  def up
  	# rename_column :users, :courses, :courses_old
  	rename_column :users, :transcript, :transcript_old
    add_column :users, :grade1, :integer
    add_column :users, :grade2, :integer
    add_column :users, :grade3, :integer
    add_column :users, :grade4, :integer

    User.reset_column_information
    # User.find_each { |user| user.update_attribute(:course1, user.courses_old) }
    User.find_each { |user| user.update_attribute(:grade1, user.transcript_old) }
    # remove_column :users, :courses_old
    remove_column :users, :transcript_old
  end
end
