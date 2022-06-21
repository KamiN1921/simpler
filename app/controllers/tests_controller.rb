# frozen_string_literal: true

class TestsController < Simpler::Controller
  def index
    @time = Time.now
  end

  def create
    render plain: 'Test created'

    status(201)
  end

  def show
    @test_id = @request.env['simpler.params'][:id]
    @time = Time.now
    status(200)
  end
end
