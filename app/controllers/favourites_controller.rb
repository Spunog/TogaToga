class FavouritesController < ApplicationController
  before_action :get_user, only: [:index,:show,:edit,:update,:destroy,:new,:create]
  before_action :set_favourite, only: [:show, :edit, :update, :destroy]

  # GET /favourites
  # GET /favourites.json
  def index
    per_page = (params.has_key?(:per_page) && params[:per_page].to_i != 0) ? params[:per_page].to_i : 4
    @favourites  = @user.favourites.joins(:movie).all.page(params[:page]).per_page(per_page)
  end

  # POST /favourites
  # POST /favourites.json
  def create
    @favourite = @user.favourites.new(favourite_params)

    respond_to do |format|
      if @favourite.save
        format.html { redirect_to [@user,:favourites], notice: 'Favourite was successfully created.' }
        format.json { render :show, status: :created, location: [@user,:favourites] }
      else
        format.html { render :new }
        format.json { render json: @favourite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favourites/1
  # DELETE /favourites/1.json
  def destroy
    @favourite.destroy
    respond_to do |format|
      format.html { redirect_to [@user,:favourites], notice: 'Favourite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favourite
      @favourite = @user.favourites.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favourite_params
      params.require(:favourite).permit(:movie_id, :user_id)
    end

    def get_user
      @user = User.find(params[:user_id])
    end

end
