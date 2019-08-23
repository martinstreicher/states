# frozen_string_literal: true

p = Participant.create! name: 'Groucho'
s = Script.create! name: 'Test', participant: p
s.transition_to :start
