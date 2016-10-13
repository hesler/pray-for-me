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
end
