class DatatablesController < ApplicationController
  #before_filter :authenticate_user!
  #load_and_authorize_resource
  respond_to :json

  def dataset
    begin
      model_class = params[:model].classify.constantize
    rescue NameError
      render :text => 'Model Not Found', :layout => false
      return
    end
    
    output = model_class.datatable(params)
    
    # Render Encoded JSON
    render :text => output.to_json, :layout => false
  end
end
