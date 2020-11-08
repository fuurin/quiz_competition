class Service::BaseController < ApplicationController
  before_action :authenticate_user!
end
