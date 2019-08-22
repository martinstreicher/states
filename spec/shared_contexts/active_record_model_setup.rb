# frozen_string_literal: true

RSpec.shared_context 'with an active record model' do |class_name:, script_name: nil|
  klass_name    = class_name.to_s.classify
  klass_table   = klass_name.downcase.pluralize
  script_name ||= klass_name

  after(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.drop_table klass_table
  end

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.create_table klass_table, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  Object.const_set(klass_name, Class.new(ApplicationRecord) { include Transitionable })

  let(:klass)         { klass_name.constantize }
  let(:machine_class) { "#{klass_name}Program".constantize }
  let(:model)         { klass.new name: script_name }
  let(:state_machine) { model.state_machine }
  let(:transitions)   { RecursiveOpenStruct.new machine_class.successors }
end
