require 'rails_helper'

RSpec.describe Admin::Invite, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
  end

  describe 'call' do
    context 'when email is wrong' do
      let(:params) { { email: 'test.test.pl' } }
      subject(:admin_command) { Admin::Invite.new(params) }

      it 'raises active model error' do
        expect { subject.call }.to raise_error(CommonErrors::CommandValidationFailed)
      end
    end

    context 'when email is not unique' do
      let(:email) { 'tewrw@we.pl' }
      let!(:admin) { create(:admin, email: email) }
      let(:params) { { email: email } }
      subject(:admin_command) { Admin::Invite.new(params) }

      it 'raises active model error' do
        expect { subject.call }.to raise_error(CommonErrors::AdminAlreadyExists)
      end
    end

    context 'when params are valid' do
      let(:email) { 'test@test.pl' }
      let(:params) { { email: email } }
      subject(:admin_command) { Admin::Invite.new(params).call }

      it 'is true' do
        expect(subject).to eq true
      end

      it 'creates an admin' do
        subject
        expect(Admin.first).not_to be_nil
        expect(Admin.first.email).to eq email
        expect(Admin.first.confirmed_at).to be_nil
        expect(Admin.first.invitation_token).not_to be_nil
      end

      it 'sends an email' do
        expect{ subject }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
