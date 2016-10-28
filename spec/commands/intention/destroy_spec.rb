require 'rails_helper'

RSpec.describe Intention::Destroy, type: :model do
  describe 'destroy' do
    let(:intention) { create(:intention) }

    context 'when valid params' do
      subject!(:intention_command) { Intention::Destroy.new(intention).call }

      it 'is true' do
        expect(intention_command).to eq true
      end

      it 'is destroyed' do
        expect(Intention.count).to eq 0
      end
    end
  end
end
