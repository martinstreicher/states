# frozen_string_literal: true

class TestProgram < Program
  program do
    say 'Hello!', id: :hello
    say 'Goodbye', id: :goodbye
  end

  def before_start
    puts 'Before starting ' + current_state
  end

  def start
    puts 'In start ' + current_state
    transition_to :hello
  end

  def after_start
    puts 'After start ' + current_state
    transition_to :hello
  end

  def after_hello
    puts 'After hello ' + current_state
    transition_to :goodbye
  end

  def before_hello
    puts 'Before hello ' + current_state
  end

  def before_goodbye
    puts 'Before goodbye ' + current_state
  end

  def after_goodbye
    puts 'After goodbye ' + current_state
  end
end
