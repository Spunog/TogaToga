class MoviesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy, :refresh, :create]
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :related]
  before_filter :set_trakt, :only => [:refresh, :show, :related]

  # GET /movies
  # GET /movies.json
  def index
    per_page = (params.has_key?(:per_page) && params[:per_page].to_i != 0) ? params[:per_page].to_i : 24
    # @movies = Movie.all.page(params[:page]).per_page(per_page)
    @movies = Movie.joins(:trending).all.page(params[:page]).per_page(per_page)

  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  def rt
    rt_movie_responce = HTTParty.get('http://www.togatoga.me/home/apiRTMovieTest.json')
    rt_movie_review_responce = HTTParty.get('http://www.togatoga.me/home/apiRTTest.json')
    @movie = rt_movie_responce
    @reviews = rt_movie_review_responce
  end

  def reddit
    reddit = HTTParty.get('http://localhost:3000/home/reddit.json')
    @reddit = reddit
  end

  def related

    @errors = []
    @relatedMovies = []

    cachedRelatedMovies = @movie.relateds

    if cachedRelatedMovies.count > 0
      @relatedMovies = cachedRelatedMovies
    else
      # Related Movies 
      # response = @trakt.getRelated(@movie.imdb_id)
      response = HTTParty.get('http://localhost:3000/home/apitest2.json') # static json file used for testing

      if response.code == 200
          response.each do |movie_item|
            movie, errorText = update_or_add_movie(:movie => movie_item, :addRank => false)
            @relatedMovies.push(movie)
            @errors.push(errorText) if not errorText.blank?
          end
      end
    end

  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # GET /movies/refresh - trending videos
  def refresh
    response = @trakt.getTrending
    # response = HTTParty.get('http://localhost:3000/home/apitest.json') # static json file used for testing

    @errors = []
    @processedMovies = []
    @result = ''
    case response.code
      when 200
        @result = '200 OK'

        # Clear Existing Trending Movies
        Trending.destroy_all()

        # Loop over movies
        response.each do |movie_item|
          movie, errorText = update_or_add_movie(:movie => movie_item, :addRank => true)
          @processedMovies.push(movie.title)
          @errors.push(errorText) if not errorText.blank?
        end

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

    def update_or_add_movie(args={})
      movie_feed = args[:movie]
      addRank = args[:addRank]
      movie = Movie.where(:imdb_id => movie_feed['imdb_id']).first_or_create :title => movie_feed['title']

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

        # Trending
        movie.build_trending if addRank

        # Save Details
        movie.save!
        errorText = ''

      rescue => e
        # @errors.push("Errors: #{e}")
        errorText = "Errors: #{e}"
      end # end try catch

      return movie, errorText

    end

end
