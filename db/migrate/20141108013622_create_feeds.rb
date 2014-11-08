class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :site
      t.integer :movie_id
      t.text :jsonData

      t.timestamps
    end
  end
end
