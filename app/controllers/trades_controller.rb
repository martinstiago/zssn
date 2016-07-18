class TradesController < ApplicationController
  def trade
    @survivor_1 = Survivor.find(trade_params[:survivor_1][:id])
    @survivor_2 = Survivor.find(trade_params[:survivor_2][:id])

    trade = Trade.new(@survivor_1, @survivor_2,
                      trade_params[:survivor_1][:resources],
                      trade_params[:survivor_2][:resources])
    trade.process

    if trade.valid
      render json: { message: trade.message }, status: :ok
    else
      render json: { error: trade.message }, status: trade.status
    end
  end

  private

  def trade_params
    params.require(:trade).permit(survivor_1: [:id, resources: [:type, :amount]],
                                  survivor_2: [:id, resources: [:type, :amount]])
  end
end
