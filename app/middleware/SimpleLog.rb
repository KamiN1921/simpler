# frozen_string_literal: true

require 'logger'
class SimpleLog
  def initialize(app, **options)
    @logger = Logger.new(options[:log] || $stdout)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(message(env))
    response
  end

  def message(env)
    controller = env['simpler.controller']
    if controller
      <<~LOGGER

        Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
        Handler:    #{controller.name.capitalize}Controller##{env['simpler.action']}
        Parameters: #{env['simpler.params']}
        Response:   #{env['simpler.response.status']} [#{env['simpler.response.header']}] #{env['simpler.template_path']}
      LOGGER
    else
      <<~LOGGER

        Request:    #{env['REQUEST_METHOD']} #{env['PATH_INFO']}
        Response:   #{env['simpler.response.status']} [#{env['simpler.response.header']}] #{env['simpler.template_path']}
      LOGGER
    end
  end
end
