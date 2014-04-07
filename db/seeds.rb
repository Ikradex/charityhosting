# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# !!! replace this information for whatever the admin's information is !!!
User.create(:id => 1, :email => "sysadmin@charityhosting.ie", :password => "admin_password", :password_confirmation => "admin_password", :f_name => "Sys", :l_name => "Admin", :is_admin => true)
User.create(:id => 2, :email => "test@example.com", :password => "test_password", :password_confirmation => "test_password", :f_name => "Example", :l_name => "User", :is_admin => false )

Charity.create(:id => 1, :domain => "corkcatactiontrust", :org_name => "Cork Cat Action Trust", :user_id => 2, :email => "secretary@catactiontrust.com", :template => 1, :charity_number => 18345, :charity_number_verified => true, :org_address => "c/o Pier View House Castle Rd Blackrock Cork", :org_tel => "353000000000", :avatar_file_name => "Ragdoll_from_Gatil_Ragbelas.jpg", :avatar_content_type => "image/jpeg", :avatar_file_size => 49985, :avatar_updated_at => "Mon, 07 Apr 2014 08:00:21 UTC +00:00")

Animal.create(:id => 1, :can_sponsor => true, :description => "Big ball of fluff looking for a new home and loving family", :charity_id => 1, :can_adopt => true, :name => "Fuzzy", :species => "Cat", :breed => "Ragdoll", :owner_email => "test@gmail.com", :avatar_file_name => "Ragdoll_from_Gatil_Ragbelas.jpg", :avatar_content_type => "image/jpeg", :avatar_file_size => 49985, :avatar_updated_at => "Mon, 07 Apr 2014 08:05:23 UTC +00:00")
Animal.create(:id => 2, :can_sponsor => true, :description => "Sharp but playful Blue Russian. We currently house Felix but he still requires support from you. Please sponsor this kitty.", :charity_id => 1, :can_adopt => false, :name => "Felix", :species => "Cat", :breed => "Blue Russian", :owner_email => "secretary@catactiontrust.com", :avatar_file_name => "mystica.jpg", :avatar_content_type => "image/jpeg", :avatar_file_size => 1980761, :avatar_updated_at => "Mon, 07 Apr 2014 08:07:31 UTC +00:00")

Post.create(:id => 1, :title => "Welcome to Cork Cat Action Trust!", :charity_id => 1, :user_id => 2, :post_content => "We are a small volunteer <b>not-for-profit</b> registered Charity (CHY345) with the main aim of reducing the numbers of unwanted cats and kittens by the tried and tested method of trap/neuter/release. Cats are trapped humanely, taken to the vet, neutered, and after a period of recuperation released back into their home territory.<div><br></div><div>Colonies of cats whether in back gardens, farms, building sites, or industrial areas, can breed so rapidly that even rabbits blink. Our aim is to stop this proliferation of unwanted kittens who live short and miserable lives and whose mothers breed and breed until they are worn out and wretched.<br></div><div><br></div><div>A pair of breeding cats can, in their lifetimes, produce <i>20,000 descendants</i> (yes twenty thousand!!).<br></div><div><br></div><div>This is a new website so please bear with us while we set everything up.</div>", :summary => "We're live! This is the first blog post of our new charity website on charityhosting.ie!")

LostCase.create(:id => 1, :owner_email => "worriedperson@email.com", :animal_name => "Munchies", :description => "Our Munchkin kitty has gone missing! :( Last seen 4 days ago in the Glasheen area in Cork. Has never been outside before so please help us!!", :charity_id => 1, :avatar_file_name => "Munchkin-cat.jpg", :avatar_content_type => "image/jpeg", :avatar_file_size => 160645, :avatar_updated_at => "Mon, 07 Apr 2014 08:13:58 UTC +00:00")

Request.create(:id => 1, :domain => "corkcatactiontrust", :org_name => "Cork Cat Action Trust", :email => "secretary@catactiontrust.com", :template => 1, :charity_number => 18345, :charity_number_verified => true, :org_address => "c/o Pier View House Castle Rd Blackrock Cork", :org_tel => "353000000000", :approved => true)
Request.create(:id => 2, :domain => "littlelifetimefoundation", :org_name => "A Little Lifetime Foundation", :email => "secretary@littlelifetimefoundation.org", :template => 1, :charity_number => 11507, :charity_number_verified => true, :org_address => "18 Orion Business Campus Rosemount Business Park Ballycoolin Blanchardstown      Dublin 15", :org_tel => "353000000000", :approved => false)
