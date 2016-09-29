require 'rails_helper'

RSpec.describe Admin::IntentionsController do
  describe 'GET index' do
    context 'with two intentions' do
      let!(:intention) { FactoryGirl.create(:intention) }
      let!(:intention2) { FactoryGirl.create(:intention) }

      subject! { get :index }

      it 'should return 200' do
        expect(subject.status).to eq 200
      end
    end
  end

  describe 'POST create' do
    context 'with correct params' do
      let(:content) { 'I need prayer' }
      let(:country) { 'England' }
      let(:city) { 'London' }
      let(:params) { { intention: { content: content, country: country, city: city, lat: 51.531133, lng: -0.226091 } } }

      subject! { post :create, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
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

      subject! { post :create, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 422' do
        expect(subject.status).to eq 422
      end

      it 'should have errors in flash' do
        expect(flash[:error].full_messages.first).to eq "Country can't be blank"
      end
    end
  end

  describe 'PUT update' do
    let(:intention) { create(:intention) }
    let(:content) { 'I need prayer' }
    let(:country) { 'England' }

    context 'with wrong id' do
      let(:params) { { id: 0, intention: { content: content, country: country } } }

      subject! { put :update, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Intention does not exist'
      end
    end

    context 'with correct params' do
      let(:params) { { id: intention.id, intention: { content: content, country: country } } }

      subject! { put :update, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
        expect(flash[:success]).to eq 'Intention updated'
      end

      it 'should updated an intention' do
        expect(Intention.count).to eq 1
        expect(Intention.first.content).to eq content
        expect(Intention.first.country).to eq country
      end
    end

    context 'with errors' do
      let(:params) { { id: intention.id, intention: { content: content, country: '' } } }

      subject! { put :update, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 422' do
        expect(subject.status).to eq 422
      end

      it 'should have errors in flash' do
        expect(flash[:error].full_messages.first).to eq "Country can't be blank"
      end
    end
  end

  describe 'POST publish' do
    let(:intention) { create(:intention) }

    context 'with correct params' do
      let(:params) { { id: intention.id } }

      subject! { post :publish, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
        expect(flash[:success]).to eq 'Intention published'
      end

      it 'should updated an intention' do
        expect(Intention.first.published?).to eq true
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 0 } }

      subject! { post :publish, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Intention does not exist'
      end
    end
  end
end
