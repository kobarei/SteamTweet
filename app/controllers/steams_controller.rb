class SteamsController < ApplicationController
  before_action :set_steam, only: [:show, :edit, :update, :destroy]

  # GET /steams
  # GET /steams.json
  def index
    @steams = Steam.all
  end

  # GET /steams/1
  # GET /steams/1.json
  def show
  end

  # GET /steams/new
  def new
    @steam = Steam.new
  end

  # GET /steams/1/edit
  def edit
  end

  # POST /steams
  # POST /steams.json
  def create
    @steam = Steam.new(steam_params)

    respond_to do |format|
      if @steam.save
        format.html { redirect_to @steam, notice: 'Steam was successfully created.' }
        format.json { render action: 'show', status: :created, location: @steam }
      else
        format.html { render action: 'new' }
        format.json { render json: @steam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /steams/1
  # PATCH/PUT /steams/1.json
  def update
    respond_to do |format|
      if @steam.update(steam_params)
        format.html { redirect_to @steam, notice: 'Steam was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @steam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steams/1
  # DELETE /steams/1.json
  def destroy
    @steam.destroy
    respond_to do |format|
      format.html { redirect_to steams_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_steam
      @steam = Steam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def steam_params
      params.require(:steam).permit(:user_id, :provider, :uid, :name, :image)
    end
end
