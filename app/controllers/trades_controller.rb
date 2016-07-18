class TradesController < ApplicationController
  def trade
    # Check for infected survivors
    survivors.each do |survivor|
      instance_variable_set("@#{survivor}", Survivor.find(trade_params[survivor][:id]))
      render(json: { error: "#{survivor.to_s.humanize} is infected! Run away from him!!!" },
             status: :conflict) && return if instance_variable_get("@#{survivor}").infected?
      instance_variable_set("@#{survivor}_resources", [])
    end

    # Check for inconsistent resources
    survivors.each do |survivor|
      trade_params[survivor][:resources].each do |resource|
        render(json: { error: "Invalid resources for #{survivor.to_s.humanize}" },
               status: :unprocessable_entity) && return unless valid_resources?(survivor, resource)
        instance_variable_set "@#{survivor}_resources",
                              instance_variable_get("@#{survivor}_resources") +
                              instance_variable_get("@#{survivor}")
                              .resources.where(type: resource[:type])
                              .first(resource[:amount].to_i)
      end
    end

    survivors.each do |survivor|
      instance_variable_set "@#{survivor}_points",
                            instance_variable_get("@#{survivor}_resources").map(&:points).inject(:+)
    end

    if @survivor_1_points == @survivor_2_points
      Resource.where(id: @survivor_1_resources).update_all(survivor_id: @survivor_2.id)
      Resource.where(id: @survivor_2_resources).update_all(survivor_id: @survivor_1.id)

      render json: { message: 'Resources where traded sucessufuly' },
             status: :ok
    else
      render json: { error: 'Invalid amount of points between both sides' },
             status: :unprocessable_entity
    end
  end

  private

  def trade_params
    params.require(:trade).permit(survivor_1: [:id, resources: [:type, :amount]],
                                  survivor_2: [:id, resources: [:type, :amount]])
  end

  def valid_resources?(survivor, resource)
    instance_variable_get("@#{survivor}").resources.where(type: resource[:type])
                                         .count >= resource[:amount].to_i
  end

  def survivors
    [:survivor_1, :survivor_2]
  end
end
