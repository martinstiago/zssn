class TradesController < ApplicationController
  def trade
    @survivor_1 = Survivor.find(trade_params[:survivor_1][:id])
    @survivor_2 = Survivor.find(trade_params[:survivor_2][:id])

    render json: { error: 'Survivor 1 is infected! Run away from him!!!' }, status: 400 and return if @survivor_1.infected?
    render json: { error: 'Survivor 2 is infected! Run away from him!!!' }, status: 400 and return if @survivor_2.infected?

    survivor_1_resources = []
    survivor_2_resources = []

    trade_params[:survivor_1][:resources].each do |resource|
      render json: { error: 'Invalid resources for survivor 1' }, status: 400 and return unless valid_resources?(@survivor_1, resource)
      survivor_1_resources += @survivor_1.resources.where(type: resource[:type]).first(resource[:amount].to_i)
    end

    trade_params[:survivor_2][:resources].each do |resource|
      render json: { error: 'Invalid resources for survivor 2' }, status: 400 and return unless valid_resources?(@survivor_2, resource)
      survivor_2_resources += @survivor_2.resources.where(type: resource[:type]).first(resource[:amount].to_i)
    end

    survivor_1_points = survivor_1_resources.map(&:points).inject(:+)
    survivor_2_points = survivor_2_resources.map(&:points).inject(:+)

    if survivor_1_points == survivor_2_points
      Resource.where(id: survivor_1_resources).update_all(survivor_id: @survivor_2.id)
      Resource.where(id: survivor_2_resources).update_all(survivor_id: @survivor_1.id)

      render json: { message: 'Resources where traded sucessufuly' },
             status: :ok
    else
      render json: { message: 'Invalid amount off point between both trade sides' },
             status: :unprocessable_entity
    end
  end

  private

  def trade_params
    params.require(:trade).permit(survivor_1: [:id, resources: [:type, :amount]],
                                  survivor_2: [:id, resources: [:type, :amount]])
  end

  def valid_resources?(survivor, resource)
    survivor.resources.where(type: resource[:type]).count <= resource[:amount].to_i
  end
end
