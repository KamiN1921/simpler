# frozen_string_literal: true

require_relative 'config/environment'

use SimpleLog, log: File.expand_path('log/app.log', __dir__)
run Simpler.application
