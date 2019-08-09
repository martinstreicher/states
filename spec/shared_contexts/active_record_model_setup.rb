# frozen_string_literal: true

RSpec.shared_context 'with an active record model' do
  after(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.drop_table :widgets
  end

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ActiveRecord::Migration.create_table :widgets, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  class Widget < ApplicationRecord # rubocop:disable RSpec/LeakyConstantDeclaration
    include Transitionable
  end

  let(:model)         { Widget.new name: :name }
  let(:state_machine) { model.state_machine }
end
