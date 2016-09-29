require 'rails_helper'

RSpec.describe Intention::Reject, type: :model do
  describe 'creation' do
    let(:intention) { create(:intention) }

    context 'when valid params' do
      subject!(:intention_command) { Intention::Reject.new(intention).call  }

      it 'is true' do
        expect(intention_command).to eq true
      end

      it 'is published' do
        expect(Intention.first.rejected?).to eq true
      end
    end
  end
end
