class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, null: false, limit: 260
      t.integer :year
      t.integer :released
      t.string :url, limit: 2083
      t.string :trailer, limit: 2083
      t.integer :runtime
      t.string :tagline
      t.string :certification
      t.string :imdb_id
      t.string :tmdb_id
      t.string :poster, limit: 2083
      t.integer :watchers

      t.timestamps
    end
  end
end
