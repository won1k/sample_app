namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User", email: "example@example.com",
			password: "foobar", password_confirmation: "foobar")
		
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@example.com"
			password = "password"
			User.create!(name: name, email: email, password: password, password_confirmation: password)
		end

		users = User.all(limit: 6) # Use only first 6 to conserve time
		50.times do # Make 50 microposts
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end