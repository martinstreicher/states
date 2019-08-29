# frozen_string_literal: true

RSpec.describe Engine do
  before do
    x_program_class =
      Class.new(Program) do
        program do
          say 'Hello!', id: :hello
          step :goodbye, retries: [1.hour, 2.hours]
        end

        def after_start
          transition_to :hello
        end

        def before_hello
          puts 'Hello'
        end

        def after_hello
          transition_to :goodbye
        end
      end

    stub_const 'XProgram', x_program_class
  end

  let(:now) { Date.today.to_time }
  let(:x)   { create :script, name: 'X' }

  it 'Advances state' do
    Timecop.freeze(now) { x.transition_to :start }

    Timecop.travel(now + 1.hour) { described_class.new.execute }
    expect(x.current_state).to eq('goodbye_retry_one')
    expect(x.transitions.last.transition_at).to eq(now + 2.hours - 1.second)

    Timecop.travel(now + 2.hours) { described_class.new.execute }
    expect(x.current_state(force_reload: true)).to eq('goodbye_retry_two')

    Timecop.travel(now.end_of_day + 5.hours + 1.second) { described_class.new.execute }
    expect(x.current_state(force_reload: true)).to eq('expire')
  end
end
