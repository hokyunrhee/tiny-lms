class HomeController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize :home
  end
end
