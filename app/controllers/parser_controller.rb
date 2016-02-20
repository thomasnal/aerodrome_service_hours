class ParserController < ApplicationController
  def index
  end

  def upload
    if params[:input_file].present?
      # Assumption: input string can fit into memory
      @notamns = Parser.new(params[:input_file].read).notamns
    end

    respond_to do |format|
      format.html { render :index }
      format.js {}
    end
  end
end
