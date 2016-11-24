require 'rails_helper'

RSpec.describe Admin::AdminsController do
  let(:admin) { create(:admin) }

  describe 'GET index' do
    context 'when not logged in' do
      subject! { get :index }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with two admins' do
      let!(:admin2) { FactoryGirl.create(:admin) }

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
      let(:email) { 'test@test.pl' }
      let(:password) { 'qazwsxedc' }
      let(:password_confirmation) { 'qazwsxedc' }
      let(:params) { { admin: { email: email, password: password, password_confirmation: password } } }

      before do
        sign_in(admin)
      end

      subject! { post :create, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_admins_path
        expect(flash[:success]).to eq 'Admin added'
      end

      it 'should create an admin' do
        expect(Admin.count).to eq 2
        expect(Admin.last.email).to eq email
      end
    end
  end

  describe 'DELETE destroy' do
    let(:admin_created) { create(:admin) }

    context 'when not logged in' do
      subject! { delete :destroy, params: { id: admin_created.id } }

      it 'should redirect to login page' do
        expect(subject).to redirect_to(new_admin_session_path)
      end
    end

    context 'with correct params' do
      let(:params) { { id: admin_created.id } }

      before do
        sign_in(admin)
      end

      subject! { delete :destroy, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(subject).to redirect_to admin_admins_path
        expect(flash[:success]).to eq 'Admin deleted'
      end

      it 'should destroy an admin' do
        expect(Admin.count).to eq 1
      end
    end

    context 'with wrong id' do
      let(:params) { { id: 0 } }

      before do
        sign_in(admin)
      end

      subject! { delete :destroy, params: params, 'Content-Type' => 'application/x-www-form-urlencoded' }

      it 'should return 302' do
        expect(subject.status).to eq 302
        expect(flash[:warning]).to eq 'Admin does not exist'
      end
    end
  end
end
