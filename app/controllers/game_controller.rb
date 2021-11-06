class GameController < ApplicationController

    def start
        require 'json'

        gol_gen = params[:gol_gen]
        gol_row = params[:gol_row]
        gol_col = params[:gol_col]
        @speed = params[:speed].to_f
        start_grid = JSON.parse(params[:grid])

        game = Game.new(gol_gen,gol_row,gol_col,@speed,start_grid)
        @out = game.execute

        render 'output'
    end

end