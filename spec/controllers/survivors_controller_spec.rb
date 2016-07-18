require 'rails_helper'

describe SurvivorsController, type: :controller do
  describe '#create' do
    let(:resources_params) do
      [
        {
          type: 'Water',
          amount: 3
        },
        {
          type: 'Food',
          amount: 5
        },
        {
          type: 'Medication',
          amount: 2
        },
        {
          type: 'Ammunition',
          amount: 66
        }
      ]
    end

    context 'with valid parameters' do
      let(:values) do
        {
          name: 'Negan',
          age: 47,
          gender: 'M',
          latitude: 38.8951100,
          longitude: -77.0363700,
          resources: resources_params
        }
      end

      it 'creates a new survivor' do
        post :create, params: { survivor: values }

        expect(response.status).to eq(201)

        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json.keys)
          .to eq(%w(id name age gender latitude longitude infected resources))

        expect(json['name']).to eq(values[:name])
        expect(json['age']).to eq(values[:age])
        expect(json['gender']).to eq(values[:gender])
        expect(json['latitude']).to eq(values[:latitude])
        expect(json['longitude']).to eq(values[:longitude])
        expect(json['infected']).to eq(false)

        expect(json['resources'].keys).to eq(%w(Water Food Medication Ammunition))
        expect(json['resources']['Water']).to eq(3)
        expect(json['resources']['Food']).to eq(5)
        expect(json['resources']['Medication']).to eq(2)
        expect(json['resources']['Ammunition']).to eq(66)
      end
    end

    context 'with invalid parameters' do
      let(:values) do
        {
          name: nil,
          age: 47,
          gender: 'M',
          latitude: nil,
          longitude: -77.0363700,
          resources: resources_params
        }
      end

      it 'returns the request errors' do
        post :create, params: { survivor: values }

        expect(response.status).to eq(422)

        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json.keys).to eq(%w(name latitude))

        expect(json['name']).to eq(["can't be blank"])
        expect(json['latitude']).to eq(["can't be blank"])
      end
    end
  end

  describe '#show' do
    context 'with a valid id' do
      let(:survivor) { create :survivor }

      it 'returns the survivor model' do
        get :show, params: { id: survivor.id }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json.keys)
          .to eq(%w(id name age gender latitude longitude infected resources))
      end
    end

    context 'with an invalid id' do
      it 'returns an error' do
        get :show, params: { id: 999 }

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['error']).to eq("Couldn't find Survivor with 'id'=999")
      end
    end
  end

  describe '#update' do
    let(:survivor) { create :survivor }

    context 'with valid parameters' do
      let(:values) do
        {
          latitude: 40.730610,
          longitude: -73.935242
        }
      end

      it 'updates the survivor values' do
        put :update, params: { id: survivor.id, survivor: values }

        expect(response.status).to eq(204)

        expect(assigns(:survivor).latitude).to eq(values[:latitude])
        expect(assigns(:survivor).longitude).to eq(values[:longitude])
      end
    end

    context 'with invalid parameters' do
      let(:values) do
        {
          latitude: 40.730610,
          longitude: nil
        }
      end

      it 'returns the request errors' do
        put :update, params: { id: survivor.id, survivor: values }

        expect(response.status).to eq(422)

        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json.keys).to eq(%w(longitude))

        expect(json['longitude']).to eq(["can't be blank"])
      end
    end
  end

  describe '#report_infection' do
    context 'with a valid id' do
      let(:survivor) { create :survivor, infection_count: 0 }

      context 'for a not infected survivor' do
        it 'increment the infection counter and returns the regular message' do
          post :report_infection, params: { id: survivor.id }

          expect(response.status).to eq(200)
          expect(assigns(:survivor).infection_count).to eq(1)

          json = JSON.parse(response.body)
          expect(json['message']).to eq('Survivor reported as infected 1 times')
        end
      end

      context 'for a infected survivor' do
        it 'increment the infection counter and returns the infected message' do
          survivor.update_column(:infection_count, Survivor::INFECTION_THRESHOLD - 1)

          post :report_infection, params: { id: survivor.id }

          expect(response.status).to eq(200)
          expect(assigns(:survivor).infection_count).to eq(Survivor::INFECTION_THRESHOLD)

          json = JSON.parse(response.body)
          expect(json['message']).to eq('Infected survivor!!! Reported as infected 3 times. Kill him!!!!')
        end
      end
    end

    context 'with an invalid id' do
      it 'returns an error' do
        post :report_infection, params: { id: 999 }

        expect(response.status).to eq(404)
        json = JSON.parse(response.body)
        expect(json['error']).to eq("Couldn't find Survivor with 'id'=999")
      end
    end
  end
end
