class ChairsController < ApplicationController
  authorize_resource only: [:new, :edit, :create, :update]

  include ApplicationHelper
  before_action :set_chair, only: [:show, :edit, :update, :find_jobs]

  # GET /chairs
  # GET /chairs.json
  def index
    @chairs = Chair.all
  end

  # GET /chairs/1
  # GET /chairs/1.json
  def show
    @running_job_offers = @chair.job_offers.running.paginate(:page => params[:page])
    @open_job_offers = @chair.job_offers.open.paginate(:page => params[:page])

    @chairs = []
  end

  # GET /chairs/new
  def new
    @chair = Chair.new
  end

  # GET /chairs/1/edit
  def edit
    if !current_user.admin? && @chair.deputy != current_user
      redirect_to @chair, notice: 'You are not allowed to edit this chair.'
    end
  end

  # POST /chairs
  # POST /chairs.json
  def create
    if !current_user.admin?
      redirect_to @chair, notice: 'You are not allowed to create a new chair.'
    end

    @chair = Chair.new(chair_params)

    respond_to do |format|
      if @chair.save
        format.html { redirect_to @chair, notice: 'Chair was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chair }
      else
				@users = User.all
        format.html { render action: 'new' }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chairs/1
  # PATCH/PUT /chairs/1.json
  def update
    if !current_user.admin? && @chair.deputy != current_user
      redirect_to @chair, notice: 'You are not allowed to update this chair.'
    end
    
    respond_to do |format|
      if @chair.update(chair_params)
        format.html { redirect_to @chair, notice: 'Chair was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chair.errors, status: :unprocessable_entity }
      end
    end
  end

  def find_jobs
    show
    render "show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chair
      @chair = Chair.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chair_params
      params.require(:chair).permit(:name, :description, :avatar, :head_of_chair, :deputy_id)
    end
end
