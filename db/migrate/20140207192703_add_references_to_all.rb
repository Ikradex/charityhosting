class AddReferencesToAll < ActiveRecord::Migration
  def change
  	add_reference :posts, :charity, index: true
  	add_reference :posts, :user, index: true
  	add_reference :charities, :user, index: true
  	add_reference :charities, :account, index: true
  	add_reference :pages, :charity, index: true
  	add_reference :pages, :content, index: true
  	add_reference :contents, :page, index: true
  	add_reference :comments, :guest, index: true
  	add_reference :comments, :user, index: true
  	add_reference :animals, :charity, index: true
  	add_reference :lost_cases, :image, index: true
  	add_reference :lost_cases, :video, index: true
  end
end
