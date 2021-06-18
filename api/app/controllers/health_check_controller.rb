class HealthCheckController < ApplicationController
  def index
    render plain: "I'm healthy!"
  end
end
