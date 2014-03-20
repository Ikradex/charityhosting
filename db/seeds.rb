# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# !!! replace this information for whatever the admin's information is !!!
User.create!({ f_name: "Sys", l_name: "Admin", email: "sysadmin@charityhosting.ie", password: "admin_password", password_confirmation: "admin_password", is_admin: true })