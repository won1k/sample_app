namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		Faker::Config.locale = :en
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
	admin = User.create!(name: "Example User", email: "example@example.com",
		password: "foobar", password_confirmation: "foobar", house: "Pax", 
		site: "Beijing", national_id: 99999999, 
		dorm: "Sample Dorm", phone: 2013102360)
	admin2 = User.create!(name: "Admin User", email: "admin@example.com",
		password: "foobar", password_confirmation: "foobar", house: "Aequitas", 
		site: "Beijing", national_id: 99999999, 
		dorm: "Sample Dorm", phone: 2013102360)
		
	admin.toggle!(:admin)
	admin2.toggle!(:admin)

	30.times do |n|
		name = Faker::Name.name
		national_id = 1010101010
		email = "example-#{n+1}@example.com"
		password = "password"
		site = "Beijing"
		house = "Pax"
		dorm = "Sample Dorm 2"
		course1 = "Sample Course 1"
		course2 = "Sample Course 2"
		course3 = "Sample Course 3"
		course4 = "Sample Course 4"
		phone = 2019999999
		User.create!(name: name, email: email, password: password, password_confirmation: password, house: house, site: site)
	end

	30.times do |n|
		name = Faker::Name.name
		national_id = 1010101010
		email = "example-#{n+1}@example.com"
		password = "password"
		site = "Shanghai"
		house = "Aequitas"
		dorm = "Sample Dorm 2"
		course1 = "Sample Course 1"
		course2 = "Sample Course 2"
		course3 = "Sample Course 3"
		course4 = "Sample Course 4"
		phone = 2019999999
		User.create!(name: name, email: email, password: password, password_confirmation: password, house: house, site: site)
	end
end

def make_microposts
	users = User.all(limit: 6) # Use only first 6 to conserve time
	50.times do # Make 50 microposts
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	users = User.all
	user = users.first
	followed_users = users[2..50]
	followers = users[3..40]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each		{ |follower| follower.follow!(user) }
end