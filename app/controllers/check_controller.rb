class CheckController < ApplicationController
    
    def upload
        
        #Input File validation
        @filetocheck = params[:inputfile].path
        file = Check.new(@filetocheck)
        @isvalid = file.fileupload

        render 'checkpage'

    end

end