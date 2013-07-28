class AddTranscriptsRecsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :transcript, :string
    add_column :users, :rec1, :text
    add_column :users, :rec2, :text
  end
end


# grade = :transcript.split(',').map(&:to_i).sum.to_f / 4