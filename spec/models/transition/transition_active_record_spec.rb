# frozen_string_literal: true

RSpec.describe Transition do
  describe 'Validations' do
    let(:now) { Time.zone.now }

    context 'when expire_at is not set and transition_at is not set' do
      it 'creates a valid transition' do
        expect(build(:transition)).to be_valid
      end
    end

    context 'when expire_at is set' do
      it 'creates a valid transition' do
        expect(build(:transition, expire_at: now)).to be_valid
      end
    end

    context 'when transition_at is set' do
      it 'creates an valid transition' do
        expect(build(:transition, transition_at: now)).to be_valid
      end
    end

    context 'when expire_at is after transition_at' do
      it 'creates an valid transition' do
        expect(build(:transition, expire_at: now.tomorrow, transition_at: now)).to be_valid
      end
    end

    context 'when expire_at and transition_at are the same time' do
      it 'creates an invalid transition' do
        expect(build(:transition, expire_at: now, transition_at: now)).not_to be_valid
      end
    end
  end
end
