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
    redirect_params = ''

    if params[:sort_by]
      @sort_by = params[:sort_by]
      session[:sort_by] = @sort_by
    elsif session[:sort_by]
      @sort_by = session[:sort_by]
    end
    redirect_params += 'sort_by=' + session[:sort_by]

    if params[:commit] == "Refresh"
      if params[:ratings]
        @selected_ratings = params[:ratings].keys
      end
      session[:ratings] = @selected_ratings
    elsif session[:ratings]
      @selected_ratings = session[:ratings]
      if not params[:ratings]
        @selected_ratings.each do |rating|
          if not redirect_params.empty?
            redirect_params += '&'
          end
          redirect_params += 'ratings[%s]=1' % rating
        end
      end
    end

    if @selected_ratings.length > 0
      conditions[:rating] = @selected_ratings
      @movies = Movie.find(:all, :order => @sort_by, :conditions => conditions)
    else
      @movies = Movie.find(:all, :order => @sort_by)
    end
    @all_ratings = Movie.find(:all, :select => "DISTINCT rating")

    if (not params[:sort_by] or not params[:ratings]) and not redirect_params.empty?
      redirect_to movies_path + '?' + redirect_params
    end
    #ratings%5BPG%5D=1&ratings%5BPG-13%5D=1&ratings%5BR%5D=1
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
