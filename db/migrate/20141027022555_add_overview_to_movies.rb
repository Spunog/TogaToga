class AddOverviewToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :overview, :text
  end
end
