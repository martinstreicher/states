# frozen_string_literal: true

RSpec.describe Hourly do
  describe 'Throttles hourly schedules' do
    let(:now) { Time.zone.now }

    context 'when no event has occurred previously' do
      it 'occurred? returns false' do
        hourly = build :hourly
        expect(hourly).not_to be_occurred
      end
    end

    context 'when an event has occurred previously more than an hour ago' do
      it 'occurred? returns false' do
        hourly = build :hourly, history: [now - 60.minutes - 1.second]
        expect(hourly).not_to be_occurred
      end
    end

    context 'when an event has occurred previously within the same hour' do
      it 'occurred? returns false' do
        hourly = build :hourly, history: [now - 30.minutes]
        expect(hourly).to be_occurred
      end
    end
  end
end
