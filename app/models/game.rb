class Game

    attr_accessor :gen, :row, :col, :speed, :grid, :new_grid

    def initialize(gen,row,col,speed,grid)
                
        @gen = gen.to_i
        @row = row.to_i
        @col = col.to_i
        @speed = speed.to_f
        @grid = grid        

    end

    def empty_grid
        #Create new empty Grid
        Array.new(@row){ Array.new(@col) { 0 } }
    end

    def execute

        #Set empty Grid for new life cicle
        @new_grid = empty_grid

        #Check cells
        @grid.each_with_index do |row, row_index|
            row.each_with_index do |cell, cell_index|

                #Find near cells
                nearcells = find_nearcells(row_index, cell_index)

                #Check near cells
                if cell == 1
                    state = nearcells.size.between?(2,3)
                else
                    state = nearcells.size == 3
                end

                #Set new cell value
                @new_grid[row_index][cell_index] = state ? 1 : 0

            end

        end

        #Check last Generation (#force loop break at 100)
        if @grid.sort != @new_grid.sort and @gen < 100
            @gen += 1            
            
            #Print New Grid            
            ##puts "Generation: "+@gen.to_s
            ##print @new_grid.map{|row| row.join(" ")}.join("\n")
            print_to_view            

            @grid = @new_grid
            execute_again
        else
            return  { gen: @gen, grid: @new_grid }
        end

    end

    def find_nearcells(row_index, cell_index)

        row_fix = true if (row_index + 1) == @row
        cell_fix = true if (cell_index + 1) == @col

        #Check near Cells
        nearcells = [
            @grid[(row_index - 1)][(cell_index - 1)],
            @grid[(row_index - 1)][(cell_index)],
            @grid[(row_index - 1)][(cell_fix ? 0 : cell_index + 1)],
            @grid[(row_index)][(cell_fix ? 0 : cell_index + 1)],
            @grid[(row_fix ? 0 : row_index + 1)][(cell_fix ? 0 : cell_index + 1)],
            @grid[(row_fix ? 0 : row_index + 1)][(cell_index)],
            @grid[(row_fix ? 0 : row_index + 1)][(cell_index - 1)],
            @grid[(row_index)][(cell_index - 1)]
        ]

        nearcells.map{|x| x if x == 1}.compact

    end

    def execute_again
        sleep @speed
        execute
    end

    def print_to_view
        #Print Grid to <table> view
        
        table = '<table style="border-collapse: collapse;">'
        @new_grid.each do |row|
            table << '<tr>'
             row.each do |col| 
                table << '<td class="'
                    if col == 0
                        table << 'bg-light'
                    else
                        table << 'bg-danger'
                    end
                table << '" style="width: 20px; height: 20px; border: 1px solid black;"></td>'
             end  
             table << '</tr>'
        end 
        table << '</table>'

        ActionCable.server.broadcast(
            "grid_channel",
            {
                gen: @gen,
                grid: table,
            }
        )

    end

end