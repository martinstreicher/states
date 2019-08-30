# frozen_string_literal: true

namespace :greenlight do
  desc 'Run on a schedule'

  task run: :environment do
    weekly_run_times =
      Montrose
      .weekly
      .on([:wednesday])
      .at('9:30 pm')
      .starting(Date.today)

    other =
      Montrose
      .every(:year, on: { 8 => 28 })
      .starting(Date.today)

    calendar =
      Montrose::Schedule.build do |schedule|
        schedule << weekly_run_times
        schedule << other
      end

    Timecop.freeze(Chronic.parse('Wednesday, 9:30pm')) do
      puts calendar.include?(Time.zone.now.localtime)
    end
  end
end
