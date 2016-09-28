require 'rails_helper'

RSpec.describe Intention::Create, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:country) }
    it { should validate_numericality_of(:lat).is_greater_than(-90) }
    it { should validate_numericality_of(:lat).is_less_than(90) }
    it { should validate_numericality_of(:lng).is_greater_than(-180) }
    it { should validate_numericality_of(:lng).is_less_than(180) }
  end

  describe 'creation' do
    context 'when invalid params' do
      let(:params) { { country: 'USA', lat: '12.1231', lng: '23.24423' } }
      subject(:intention_command) { Intention::Create.new(params) }

      it 'raises active model error' do
        expect { intention_command.call }.to raise_error(CommonErrors::CommandValidationFailed)
      end
    end

    context 'when valid params' do
      let(:params) { { country: 'USA', content: 'Test contntent', lat: '12.1231', lng: '23.24423' } }
      subject!(:intention_command) { Intention::Create.new(params).call  }

      it 'is true' do
        expect(intention_command).to eq true
        expect(Intention.first).not_to be_nil
      end

      it 'is not published' do
        expect(Intention.first.published?).to eq false
      end
    end
  end
end
