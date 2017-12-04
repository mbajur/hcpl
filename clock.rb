require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    if job == 'refresh_scores.job'
      RefreshEventScores.run!
    end
  end

  # handler receives the time when job is prepared to run in the 2nd argument
  # handler do |job, time|
  #   puts "Running #{job}, at #{time}"
  # end

  every(1.hour, 'refresh_scores.job')
end
