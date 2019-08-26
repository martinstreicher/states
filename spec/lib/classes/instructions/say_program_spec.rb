# frozen_string_literal: true

RSpec.describe Program do
  before do
    x_program_class =
      Class.new(described_class) do
        plan do
          say 'hello', id: :weekly_say, kind: :sms
        end
      end

    stub_const 'XProgram', x_program_class
  end

  let(:x) { create :script, name: 'X' }

  describe 'it works' do
    it 'works' do
      1
    end
  end
end
