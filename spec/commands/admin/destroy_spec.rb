require 'rails_helper'

RSpec.describe Admin::Destroy, type: :model do
  describe 'destroy' do
    let(:admin) { create(:admin) }

    context 'when valid params' do
      subject!(:admin_command) { Admin::Destroy.new(admin).call }

      it 'is true' do
        expect(admin_command).to eq true
      end

      it 'is destroyed' do
        expect(Admin.count).to eq 0
      end
    end
  end
end
