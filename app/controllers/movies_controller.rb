class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = nil # default sorting
    @selected_ratings = [] #default rating filter
    conditions = {}

    if params[:sort_by]
      @sort_by = params[:sort_by]
      flash[:sort_by] = @sort_by
    elsif flash[:sort_by]
      @sort_by = flash[:sort_by]
      flash[:sort_by] = @sort_by
    end

    if params[:commit] == "Refresh"
      if params[:ratings]
        @selected_ratings = params[:ratings].keys
      end
      flash[:ratings] = @selected_ratings
    elsif flash[:ratings]
      @selected_ratings = flash[:ratings]
      flash[:ratings] = @selected_ratings
    end

    if @selected_ratings.length > 0
      conditions[:rating] = @selected_ratings
      @movies = Movie.find(:all, :order => @sort_by, :conditions => conditions)
    else
      @movies = Movie.find(:all, :order => @sort_by)
    end
    @all_ratings = Movie.find(:all, :select => "DISTINCT rating")
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
