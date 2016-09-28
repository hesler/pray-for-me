require 'rails_helper'

RSpec.describe Admin::IntentionsController do
  describe 'GET index' do
    context 'with two intentions' do
      let!(:intention) { FactoryGirl.create(:intention) }
      let!(:intention2) { FactoryGirl.create(:intention) }
      before do
        get :index
      end

      it 'should return 200' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST create' do
    context 'with correct params' do
      let(:content) { 'I need prayer' }
      let(:country) { 'England' }
      let(:city) { 'London' }
      let(:params) { { intention: { content: content, country: country, city: city, lat: 51.531133, lng: -0.226091 } } }

      before do
        post :create, params: params, 'Content-Type' => 'application/x-www-form-urlencoded'
      end

      it 'should return 302' do
        expect(response.status).to eq 302
        expect(flash[:success]).to eq 'Intention added'
      end

      it 'should create an intention' do
        expect(Intention.count).to eq 1
        expect(Intention.first.content).to eq content
        expect(Intention.first.country).to eq country
        expect(Intention.first.city).to eq city
      end
    end

    context 'with errors' do
      let(:content) { 'I need prayer' }
      let(:city) { 'London' }
      let(:params) { { intention: { content: content, country: '', city: city, lat: 51.531133, lng: -0.226091 } } }

      before do
        post :create, params: params, 'Content-Type' => 'application/x-www-form-urlencoded'
      end

      it 'should return 200' do
        expect(response.status).to eq 200
      end

      it 'should have errors in flash' do
        expect(flash[:error].full_messages.first).to eq "Country can't be blank"
      end
    end
  end
end
