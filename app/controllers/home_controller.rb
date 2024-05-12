class HomeController < ApplicationController
  def store
    @prizes = Prize.all
  end

  def landing
    reset_session
    render layout: 'landing'
  end
end
