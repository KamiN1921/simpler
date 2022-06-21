# frozen_string_literal: true

require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      status(200)
      send(action)
      write_response

      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = headers['Content-Type']

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def headers
      @response.headers
    end

    def status(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      if template.key?(:plain)
        headers['Content-Type'] = 'text/plain'
        template = 'text'
      end

      @request.env['simpler.template'] = template
    end
  end
end
