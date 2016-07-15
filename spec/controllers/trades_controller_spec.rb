require 'rails_helper'

describe TradesController, type: :controller do
  describe '#trade' do
    let(:survivor_1) { create :survivor }
    let(:survivor_2) { create :survivor }

    let!(:water_resources) { create :water, survivor: survivor_1 }
    let!(:food_resources) { create_list :food, 2, survivor: survivor_1 }
    let!(:medication_resources) { create_list :medication, 2, survivor: survivor_2 }
    let!(:ammunition_resources) { create_list :ammunition, 6, survivor: survivor_2 }

    let(:survivor_1_resources) do
      [
        {
          type: 'Water',
          amount: 1
        },
        {
          type: 'Food',
          amount: 2
        }
      ]
    end

    let(:survivor_2_resources) do
      [
        {
          type: 'Medication',
          amount: 2
        },
        {
          type: 'Ammunition',
          amount: 6
        }
      ]
    end

    let(:request_params) do
      {
        trade: {
          survivor_1: {
            id: survivor_1.id,
            resources: survivor_1_resources
          },
          survivor_2: {
            id: survivor_2.id,
            resources: survivor_2_resources
          }
        }
      }
    end

    it 'trades resources between survivors' do
      post :trade, params: request_params

      expect(response.status).to eq(200)

      json = JSON.parse(response.body)
      expect(json['message']).to eq('Resources where traded sucessufuly')
    end

    context 'when a survivor is not found' do

    end

    context 'when a survivor is infected' do

    end

    context 'when a survivor does not have the described resources' do

    end

    context 'when sides offer distinct amount of points' do

    end
  end
end
