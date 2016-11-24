require 'rails_helper'

RSpec.describe Admin::Create, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'call' do
    context 'when email is wrong' do
      let(:params) { { email: 'test.test.pl', password: 'qazwsxedc', password_confirmation: 'qazwsxedc' } }
      subject(:admin_command) { Admin::Create.new(params) }

      it 'raises active model error' do
        expect { admin_command.call }.to raise_error(CommonErrors::CommandValidationFailed)
      end
    end

    context 'when email is not unique' do
      let(:email) { 'tewrw@we.pl' }
      let!(:admin) { create(:admin, email: email) }
      let(:params) { { email: email, password: 'qazwsxedc', password_confirmation: 'qazwsxedc' } }
      subject(:admin_command) { Admin::Create.new(params) }

      it 'raises active model error' do
        expect { admin_command.call }.to raise_error(CommonErrors::AdminAlreadyExists)
      end
    end

    context 'when passwords dont match' do
      let(:email) { 'tewrw@we.pl' }
      let(:params) { { email: email, password: 'qazwsxedc', password_confirmation: nil } }
      subject(:admin_command) { Admin::Create.new(params) }

      it 'raises active model error' do
        expect { admin_command.call }.to raise_error(CommonErrors::CommandValidationFailed)
      end
    end

    context 'when params are valid' do
      let(:email) { 'test@test.pl' }
      let(:password) { 'qazwsxedc' }
      let(:password_confirmation) { 'qazwsxedc' }
      let(:params) { { email: email, password: password, password_confirmation: password } }
      subject!(:admin_command) { Admin::Create.new(params).call }

      it 'is true' do
        expect(admin_command).to eq true
      end

      it 'created an admin' do
        expect(Admin.first).not_to be_nil
        expect(Admin.first.email).to eq email
      end
    end
  end
end
