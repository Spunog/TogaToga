class CreateTrendings < ActiveRecord::Migration
  def change
    create_table :trendings do |t|
      t.integer :movie_id
      t.integer :rank

      t.timestamps
    end
  end
end
