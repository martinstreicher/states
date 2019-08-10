# frozen_string_literal: true

RSpec.shared_context 'with an active record model' do |class_name:|
  klass_name  = class_name.to_s.classify
  klass_table = klass_name.downcase.pluralize

  after(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.drop_table klass_table
  end

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.create_table klass_table, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  Object.const_set(klass_name, Class.new(ApplicationRecord) { include Transitionable })

  let(:model)         { klass_name.constantize.new name: :name }
  let(:state_machine) { model.state_machine }
end
