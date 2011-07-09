module Datatables
  module Helpers
    def datatable(modelname,columns,options={},jsoptions={})
      if modelname.kind_of? Array
        @modelname = modelname[0].to_s
        @scope = modelname[1].to_s
        @id = modelname[2]
      else
        @modelname = modelname.to_s
      end
      
      @columns = columns
      @jsoptions = jsoptions
      @pptions = options
      
      @col_str = ""
      @columns.each_pair do |key,col|
        @col_str += "," unless @columns.keys.first == key
        @col_str += key.to_s
        if !col[:column].nil?
          real_column_name = col[:column].gsub( /[\.#|]/, ":" )
          @col_str += ":#{real_column_name}"
          logger.debug real_column_name
          logger.debug @col_str
        end
      end
      
      render :partial => '/datatable/datatable'
    end
  end
end