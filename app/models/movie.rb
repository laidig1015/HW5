class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 R)
  end

  def Movie::find_in_tmdb (search_terms)
  	movies_result = []
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
  	movies = Tmdb::Movie.find(search_terms)
  	movies.each do |m|
  		temp_hash = {}
  		temp_hash[:title] = m.title
  		temp_hash[:tmdb_id] = m.id
  		temp_hash[:rating] = "PG"
  		temp_hash[:release_date] = m.release_date
  		movies_result << temp_hash
  	end
  	return movies_result
  end


  def Movie::create_from_tmdb(movies_to_add)
    movies_to_add.each do |id|
      details = Tmdb::Movie.detail(id)
      title = details["title"]
      release_date = details["release_date"]
      rating = "PG"
      temp_hash = {"title" => title,"release_date" => release_date,"rating" => rating}
      Movie.create!(temp_hash)
    end
  end
end