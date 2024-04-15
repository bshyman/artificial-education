class HomeController < ApplicationController
  def store
    @prizes = Prize.all
  end
end
