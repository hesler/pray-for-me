require 'rails_helper'

RSpec.describe Admin::IntentionsController do
  let(:admin) { create(:admin) }

  describe 'GET index' do
    context 'when not logged in' do
      subject! { get :index }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with two intentions' do
      let!(:intention) { FactoryGirl.create(:intention) }
      let!(:intention2) { FactoryGirl.create(:intention) }

      before do
        sign_in(admin)
      end

      subject! { get :index }

      it 'should return 200' do
        expect(subject.status).to eq 200
      end
    end
  end

  describe 'POST create' do
    context 'when not logged in' do
      subject! { post :create }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with correct params' do
      let(:content) { 'I need prayer' }
      let(:country) { 'England' }
      let(:city) { 'London' }
      let(:params) { { intention: { content: content, country: country, city: city, lat: 51.531133, lng: -0.226091 } } }

      before do
        sign_in(admin)
      end

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

      before do
        sign_in(admin)
      end

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

    context 'when not logged in' do
      subject! { put :update, params: { id: intention.id } }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 0, intention: { content: content, country: country } } }

      before do
        sign_in(admin)
      end

      subject! { put :update, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Intention does not exist'
      end
    end

    context 'with correct params' do
      let(:params) { { id: intention.id, intention: { content: content, country: country } } }

      before do
        sign_in(admin)
      end

      subject! { put :update, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
        expect(flash[:success]).to eq 'Intention updated'
      end

      it 'should update an intention' do
        expect(Intention.count).to eq 1
        expect(Intention.first.content).to eq content
        expect(Intention.first.country).to eq country
      end
    end

    context 'with errors' do
      let(:params) { { id: intention.id, intention: { content: content, country: '' } } }

      before do
        sign_in(admin)
      end

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

    context 'when not logged in' do
      subject! { post :publish, params: { id: intention.id } }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with correct params' do
      let(:params) { { id: intention.id } }

      before do
        sign_in(admin)
      end

      subject! { post :publish, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
        expect(flash[:success]).to eq 'Intention published'
      end

      it 'should update an intention' do
        expect(Intention.first.published?).to eq true
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 0 } }

      before do
        sign_in(admin)
      end

      subject! { post :publish, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Intention does not exist'
      end
    end
  end

  describe 'POST reject' do
    let(:intention) { create(:intention) }

    context 'when not logged in' do
      subject! { post :reject, params: { id: intention.id } }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with correct params' do
      let(:params) { { id: intention.id } }

      before do
        sign_in(admin)
      end

      subject! { post :reject, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_intentions_path
        expect(flash[:success]).to eq 'Intention rejected'
      end

      it 'should update an intention' do
        expect(Intention.first.rejected?).to eq true
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 0 } }

      before do
        sign_in(admin)
      end

      subject! { post :publish, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Intention does not exist'
      end
    end
  end
end
