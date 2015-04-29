# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create categories
Category.destroy_all

categories_hash = [
		               {name: 'Fiction'},
                   {name: 'Adventure'},
                   {name: 'Children'},
                   {name: 'Crime'},
                   {name: 'Legend'},
                   {name: 'Horror'},
                   {name: 'Sagas'},
                   {name: 'Non-Fiction'},
                   {name: 'Thrillers'},
                   {name: 'Contemporary'}
                 ]
Category.create(categories_hash)




cats = Category.all

cats.each do |cat|
	500.times do |i|
		cat.books.create({title: Faker::Name.title, number_of_pages: (10 * i),coverimage:'http://loremflickr.com/320/240', publish_date: 2000})
	end
end