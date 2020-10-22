class Movie < ActiveRecord::Base
  @@all_ratings = ['G', 'PG', 'PG-13', 'R']
  
  def self.all_ratings
    @@all_ratings
  end
  
  def self.with_ratings(ratings)
    if ratings.empty?
      self.all
    else
      self.where(rating: ratings)
    end
  end
  
  def self.title_sorted
    self.order(:title)
  end
  
  def self.date_sorted
    self.order(:release_date)
  end
end
