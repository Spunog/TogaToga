class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url, limit: 2083
      t.string :type_id
      t.integer :movie_id

      t.timestamps
    end
 
	 # many to many
	 # create_table :movie_images, id: false do |t|
	 #      t.belongs_to :movie
	 #      t.belongs_to :image
	 #    end

  end
end