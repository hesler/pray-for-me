 require 'rails_helper'

 RSpec.describe Admin::WelcomeController, type: :controller do
   describe 'GET #index' do
     let(:admin) { create(:admin) }

     it 'should redirect not logged in admin' do
       expect(get :index).to redirect_to(new_admin_session_path)
     end

     it 'should allow only logged in admin' do
       sign_in(admin)
       expect(get :index).to have_http_status(200)
     end
   end
 end
