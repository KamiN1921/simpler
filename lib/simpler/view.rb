# frozen_string_literal: true

require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = [controller.name, action].join('/')
      templ_path = template || path

      if template == 'text'
        @env['simpler.template_path'] = "#{path}.text.erb"
        Simpler.root.join(VIEW_BASE_PATH, "#{path}.text.erb")
      else
        @env['simpler.template_path'] = "#{path}.html.erb"
        Simpler.root.join(VIEW_BASE_PATH, "#{templ_path}.html.erb")
      end
    end
  end
end
