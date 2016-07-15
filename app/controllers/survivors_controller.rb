class SurvivorsController < ApplicationController
  before_action :find_survivor, except: :create

  def create
    @survivor = Survivor.new(survivor_params.merge(resources_attributes: parsed_resources))
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
    if @survivor.infected?
      render json: { message: "Infected survivor!!! Reported as infected #{@survivor.infection_count} times. Kill him!!!!" },
             status: :ok
    else
      render json: { message: "Survivor reported as infected #{@survivor.infection_count} times" },
             status: :ok
    end
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
    resources_params[:resources].each do |resource|
      resource[:amount].to_i.times { resources << { type: resource[:type] } }
    end
    resources
  end
end
