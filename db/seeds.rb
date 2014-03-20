# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# !!! replace this information for whatever the admin's information is !!!
User.create!({ f_name: "Dan", l_name: "Morgan", email: "morgandaniel1992@gmail.com", password: "abc123", password_confirmation: "abc123", is_admin: true })
