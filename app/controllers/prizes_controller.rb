class PrizesController < ApplicationController
  def new
    @prize = Prize.new
  end
end
