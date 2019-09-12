# frozen_string_literal: true

module Schedules
  module Greenlight
    RSpec.describe Pace do
      describe 'pace operates hourly' do
        subject(:pace) { described_class.new participant, time: now - 2.hours }

        let(:participant) { create :participant }
        let(:now)         { Time.zone.now }

        context 'when nothing has previously run' do
          it 'the task is due' do
            expect(pace).to be_due
          end
        end

        context 'when a run has occurred within the last hour' do
          it 'the task is due' do
            pace.history << now - 30.minutes
            expect(pace).not_to be_due
          end
        end

        context 'when a run has occurred more than an hour ago' do
          it 'the task is due' do
            pace.history << now - 60.minutes
            expect(pace).to be_due
          end
        end
      end
    end
  end
end
