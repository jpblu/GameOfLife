class GameController < ApplicationController

    def index
    end

    def upload
        #Input File validation
        @filetocheck = params[:inputfile].path
        file = Check.new(@filetocheck)
        @game = file.fileupload
    end

    def start
        require 'json'

        gol_gen = params[:gol_gen]
        gol_row = params[:gol_row]
        gol_col = params[:gol_col]
        @speed = params[:speed].to_f
        start_grid = JSON.parse(params[:grid])

        game = Game.new(gol_gen,gol_row,gol_col,@speed,start_grid)

        Rails.cache.write('game-status', 'running')
        @out = game.execute
    end

    def stop
        Rails.cache.write('game-status', 'stopped')

        render head :no_content
    end

end