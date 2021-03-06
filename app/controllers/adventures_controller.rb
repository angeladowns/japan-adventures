class AdventuresController < ApplicationController
  before_action :set_adventure, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :owns_adventure, only: [:edit, :update, :destroy]
  before_action :prepare_categories
  # GET /adventures
  # GET /adventures.json
  def index
    @adventures = Adventure.all.order("updated_at DESC")

  #if params[:search]
  #  @adventures = Adventure.search(params[:search]).order("created_at DESC")
  #else
  #  @adventures = Adventure.all.order("created_at DESC")
  #end

  end

  def search
    if params[:search]
      @adventures = Adventure.search(params[:search]).order("created_at DESC")
    else
      @adventures = Adventure.all.order("created_at DESC")
    end
  end


  # GET /adventures/1
  # GET /adventures/1.json
  def show
    @adventure = Adventure.find(params[:id])
  end

  # GET /adventures/new
  def new
    @adventure = Adventure.new
    @adventure = current_user.adventures.build
  end

  # GET /adventures/1/edit
  def edit
  end

  # POST /adventures
  # POST /adventures.json
  def create
    @adventure = current_user.adventures.new(adventure_params)
    @adventure = Adventure.new(adventure_params)
    respond_to do |format|
      if @adventure.save
        format.html { redirect_to @adventure, notice: 'Adventure was successfully created.' }
        format.json { render :show, status: :created, location: @adventure }
      else
        format.html { render :new }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adventures/1
  # PATCH/PUT /adventures/1.json
  def update
    respond_to do |format|
      if @adventure.update(adventure_params)
        format.html { redirect_to @adventure, notice: 'Adventure was successfully updated.' }
        format.json { render :show, status: :ok, location: @adventure }
      else
        format.html { render :edit }
        format.json { render json: @adventure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adventures/1
  # DELETE /adventures/1.json
  def destroy
    @adventure.destroy
    respond_to do |format|
      format.html { redirect_to adventures_url, notice: 'Adventure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adventure
      @adventure = Adventure.find(params[:id])
    end

    # add the @categories = Category.All to the before action so avail for all actions
     def prepare_categories
      @categories = Category.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adventure_params
      params.require(:adventure).permit(:name, :description, :picture, :location, :visit, :address, :user_id, :category_id)
    end

    def owns_adventure
      if !user_signed_in? || current_user != Adventure.find(params[:id]).user
        redirect_to adventures_path, error: "You cannot do that"
      end
    end
end
