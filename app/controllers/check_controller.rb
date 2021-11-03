class CheckController < ApplicationController
    
    def upload
        
        #Input File validation
        @uploaded_file = params[:inputfile].path
        @isvalid = false
        @gol_gen = 0
        @gol_row = 0
        @gol_col = 0
        @err_out = ''
        @grid = Array.new
        i = 0

        #Check file row
        File.foreach(@uploaded_file).with_index do |line, line_no|
            i += 1

            #Line 0: Check Generation N
            if line_no == 0
                regex = Regexp.new('^Generation [0-9]+:$', )
                if regex.match?(line.strip)
                    @isvalid = true
                    @gol_gen = line.scan(/\d+/)[0]
                else
                    @isvalid = false
                    @err_out = "Line 1: syntax error"
                    break
                end
            
            end

            #Line 1: Check Grid R x C
            if line_no == 1
                regex = Regexp.new('^[0-9]+ [0-9]+$', )
                if regex.match?(line.strip)
                    @isvalid = true
                    @gol_row = line.scan(/\d+/)[0]
                    @gol_col = line.scan(/\d+/)[1]
                else
                    @isvalid = false
                    @err_out = "Line 2: syntax error or not numeric value"
                    break
                end
            end

            #Line > 1: Check Grid Cell State & Grid Column Lenght
            if line_no > 1
                regex = Regexp.new('^[.*]*$', )
                if regex.match?(line.strip) && line.strip.length.to_i == @gol_col.to_i
                    @grid.push(line.strip.gsub(".","0").gsub("*","1").split(//).map(&:to_i))
                    @isvalid = true
                else
                    @isvalid = false
                    @err_out = "Line "+line_no.to_s+": syntax error, only . and * char permitted or grid not match column declared"
                    break
                end
            end

        end

        #Check file Grid rows
        if (i-2).to_i != @gol_row.to_i && @isvalid
            @isvalid = false
            @err_out = "Grid not match lines declared. "+@gol_row.to_s+" declared, "+(i-2).to_s+" present."
        end

        render 'checkpage'

    end
  end