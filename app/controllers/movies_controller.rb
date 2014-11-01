class MoviesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy, :refresh, :create]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_filter :set_trakt, :only => [:refresh]

  # GET /movies
  # GET /movies.json
  def index
    per_page = (params.has_key?(:per_page) && params[:per_page].to_i != 0) ? params[:per_page].to_i : 24
    @movies = Movie.all.page(params[:page]).per_page(per_page)
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    fanart = @movie.images.find_by! type_id: 'fanart'
    poster = @movie.images.find_by! type_id: 'poster'
    @fanArtURL = fanart.url.gsub(/.jpg/,'-940.jpg') # use smaller fan art size for faster loading
    @posterURL = poster.url.gsub(/.jpg/,'-300.jpg') # use smaller poster for faster loading
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # GET /movies/refresh
  def refresh
    response = @trakt.getTrending
    @errors = []
    @processedMovies = []
    @result = ''
    case response.code
      when 200
        @result = '200 OK'

        Movie.destroy_all
        movieslist = response

        # Loop over movies
        movieslist.each do |movie_feed|
          movie = Movie.new

          begin
            # Main Details
            movie.title         =   movie_feed['title']
            movie.year          =   movie_feed['year']
            movie.released      =   movie_feed['released']
            movie.url           =   movie_feed['url']
            movie.trailer       =   movie_feed['trailer']
            movie.runtime       =   movie_feed['runtime']
            movie.tagline       =   movie_feed['tagline']
            movie.certification =   movie_feed['certification']
            movie.imdb_id       =   movie_feed['imdb_id']
            movie.tmdb_id       =   movie_feed['tmdb_id']
            movie.poster        =   movie_feed['poster']
            movie.watchers      =   movie_feed['watchers']

            # Overview
            if movie_feed.has_key?("overview") && !movie_feed['overview'].nil?
              movie.overview      =   movie_feed['overview'].truncate(2000, :length=>2000)
            else
              movie.overview = ''
            end

            # Images - Poster
            if movie_feed['images'].has_key?("poster")
              poster = movie.images.new
              poster.type_id = 'poster'
              poster.url = movie_feed['images']['poster']
            end

            # Images - Fanart
            if movie_feed['images'].has_key?("fanart")
              fanart = movie.images.new
              fanart.type_id = 'fanart'
              fanart.url = movie_feed['images']['fanart']
            end

            # Save Details
            movie.save!

            # Make note of movie processed
            @processedMovies.push(movie.title)

          rescue => e
            @result = '200 connected to API successful but problem processing data.'
            @errors.push("Errors: #{e}")
          end # end try catch

        end # end loop 

      when 404
        @result = '404 Not Found'
      when 500...600
        @result = "ERROR #{response.code}"
    end

  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :year, :released, :url, :trailer, :runtime, :tagline, :certification, :imdb_id, :tmdb_id, :poster, :watchers)
    end

    def set_trakt
      @trakt = Api::Trakt.new(:apikey => ENV["TRAKT_API_KEY"])
    end

end
