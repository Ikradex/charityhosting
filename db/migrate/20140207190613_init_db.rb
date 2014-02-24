class InitDb < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :email
  		t.string :password_digest
  		t.string :password
  		t.string :password_confirmation
  		t.string :f_name
  		t.string :l_name
  	end

  	create_table :charities do |t|
  		t.string :domain
  		t.string :org_name
  	end

  	create_table :guests do |t|
  		t.string :email
  		t.string :username
  		t.string :password_digest
  		t.string :password
  		t.string :password_confirmation
  	end

  	create_table :pages do |t|
  		t.string :title
  	end

  	create_table :posts do |t|
  		t.string :title
  		t.datetime :timestamp
  	end

  	create_table :comments do |t|
  		t.text :content
  		t.datetime :timestamp
  	end

  	create_table :accounts do |t|
  		t.float :income
  		t.float :expenditure
  		t.datetime :timestamp
  	end

  	create_table :donations do |t|
  		t.float :amount
  		t.datetime :timestamp
  	end

  	create_table :contents do |t|
  		t.text :content_src
  	end

  	create_table :images do |t|
  		t.string :data_src
  		t.string :alt_desc
  		t.string :mime_type
  	end

  	create_table :videos do |t|
  		t.string :data_src
  		t.string :title
  	end

  	create_table :animals do |t|
  		t.string :name
  		t.string :species
  		t.string :breed
  		t.boolean :can_adopt
  	end

  	create_table :lost_cases do |t|
  		t.string :owner_email
  		t.string :animal_name
  	end
  end
end
