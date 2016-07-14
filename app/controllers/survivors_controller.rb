class SurvivorsController < ApplicationController
  before_action :find_survivor, except: :create
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    @survivor = Survivor.new(survivor_params, resources_attributes: parsed_resources)
    if @survivor.save
      render json: @survivor, status: :created
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @survivor
  end

  def update
    if @survivor.update_attributes(update_params)
      head :no_content, status: :ok
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def report_infection
    @survivor.increment(:infection_count, 1)
    head :no_content, status: :ok
  end

  private

  def find_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude)
  end

  def resources_params
    params.require(:survivor).permit(resources: [:type, :amount])
  end

  def update_params
    params.require(:survivor).permit(:latitude, :longitude)
  end

  def parsed_resources
    resources = []
    resources_params.each do |resource|
      resource[:amount].times { resources << [type: resource[:type]] }
    end
    resources
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end