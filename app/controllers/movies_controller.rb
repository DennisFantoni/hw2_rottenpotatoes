class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    doredirect=false
    if params[:order].nil?
       params[:order]=session[:order]
       doredirect=true
    end

    if params[:ratings].nil?
      params[:ratings]=session[:ratings]
      doredirect=true
    end

    if doredirect 
      flash.keep
      redirect_to movies_path (params)
    end

    @titlehilite=''
    @datehilite=''
    if params[:order]=='title' then
      @titlehilite='hilite'
    end
    if params[:order]=='release_date' then
      @datehilite='hilite'
    end
    @all_ratings=Movie.all_ratings
#    myhash = Hash.new
#    myhash.add(params[:ratings])
     if params[:ratings].nil?
       mykeys=[]
     else
       if params[:ratings].class!=Array
         mykeys=params[:ratings].keys
       else
         mykeys=params[:ratings]
       end
     end

     
     @selected_ratings=mykeys
     @lastorder=params[:order]     
     
     @movies = Movie.where({:rating => mykeys}).all(:order=>params[:order])
#    @movies = Movie.where({:rating => ['G','PG']}).all(:order => 'title')
#    @movies = Movie.order(params[:order])
#    flash[:notice]=params
     session[:ratings]=@selected_ratings
     session[:order]=@lastorder
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
