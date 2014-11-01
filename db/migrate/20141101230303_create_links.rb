class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :movie_id
      t.integer :related_id

      t.timestamps
    end
  end
end
