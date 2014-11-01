class Link < ActiveRecord::Base
  belongs_to :movie
  belongs_to :related, :class_name => 'Movie'

  # Creates the complementary link automatically - this means all relatedous
  # relationships are represented in @movie.relateds
  def after_save_on_create
    if find_complement.nil?
      Link.new(:movie => related, :related => movie).save
    end
  end

  # Deletes the complementary link automatically.
  def after_destroy
    if complement = find_complement
      complement.destroy
    end
  end

  protected

  def find_complement
    Link.find(:first, :conditions => 
      ["movie_id = ? and related_id = ?", related.id, movie.id])
  end
end