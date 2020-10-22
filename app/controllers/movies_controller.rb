class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    puts
    if (params.keys & ["ratings", "title_sorted", "date_sorted"]).empty?
      redirect_to movies_path(:title_sorted=>session[:sorted_title], :date_sorted=>session[:sorted_date], :ratings=>Hash[session[:rating].collect {|r| [r, 1]}])
    end
    
    if params[:ratings].nil?
      @ratings_to_show = @all_ratings
    else
      @ratings_to_show = params[:ratings].keys
    end
    
    @movies = Movie.with_ratings(@ratings_to_show)
    
    if params[:title_sorted] == "true"
      @movies = @movies.title_sorted
      @title_color = "bg-warning"
    end 
    
    if params[:date_sorted] == "true"
      @movies = @movies.date_sorted
      @date_color = "bg-warning"
    end 
    
    session[:rating] = @ratings_to_show
    session[:sorted_date] = params[:date_sorted]
    session[:sorted_title] = params[:title_sorted]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
