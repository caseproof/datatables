# Adds the datatable method in ActiveRecord::Base, which sets up the backend for the datatable javascript
#
class << ActiveRecord::Base
  def datatable( params )
    curr_model = self
    table_name = curr_model.table_name

    if curr_model.try :metafied?
      metas = curr_model.metafied_attrs || []
    else
      metas = []
    end

    sql_opts = { :select => [], :limit => "", :order => "", :joins => [], :conditions => "" }
    columns = []
    full_columns = []

    dscope = params[:scope] || nil
    dcols =  params[:columns].split(',')
    did =    params[:id]

    dcols.each do |col|
      col = col.split(':')
      if col.length > 1 # association (already assumed we're joined within a scope)
        col_fmt = "`#{col[1].to_s}`.`#{col[2].to_s}`"
      elsif metas.include? col.first.to_sym
        col_fmt = "`m_#{col.first.to_s}`.`meta_value`"
      else
        col_fmt = "`#{table_name.to_s}`.`#{col.first.to_s}`"
      end

      columns.push col.first.to_s
      full_columns.push col_fmt
      sql_opts[:select].push "#{col_fmt} as #{col.first.to_s}"
    end

    # Paging
	  if params['iDisplayStart'] and params['iDisplayLength'] != '-1'
  	  sql_opts[:limit]  = "#{params['iDisplayStart']},#{params['iDisplayLength']}"
  	end

    # Ordering
    if params['iSortCol_0']
  	  orders = []
  	  i = 0
  	  while i < params['iSortingCols'].to_i do
  	    if params['bSortable_' + params['iSortCol_' + i.to_s]] == "true"
  	      # Make sure the order works for metafied columns and normal columns
  	      col = full_columns[ params['iSortCol_' + i.to_s].to_i ]
  	      orders.push( "#{col} #{params['sSortDir_' + i.to_s]}" )
  	    end
  	    i += 1
  	  end
  	  sql_opts[:order] = orders.join(", ") unless orders.empty?
  	end

  	# Searching
  	search_str = ""
  	searches = []
  	if params['sSearch'] and !params['sSearch'].empty?
  	  full_columns.each_with_index do |col,i|
  	    searches.push( "#{col} LIKE '%#{params['sSearch']}%'" )
  	  end
  	  search_str = searches.join(' OR ') unless searches.empty?
  	end
  
  	# Filtering
  	filter_str = ""
  	filters = []
  	full_columns.each_with_index do |col,i|
  	  if params['bSearchable_' + i.to_s] == "true" and !params['sSearch_' + i.to_s].empty?
  	    filters.push( "#{col} LIKE '%#{params['sSearch_' + i.to_s]}%'" )
  	  end
  	end
  	filter_str = filters.join(' AND ') unless filters.empty?
  
  	# Pull Searching & Filtering into where
  	if !searches.empty? and !filters.empty?
  	  sql_opts[:conditions] = "(#{search_str}) AND #{filter_str}"
  	elsif !searches.empty?  
  	  sql_opts[:conditions] = search_str
  	elsif !filters.empty?   
  	  sql_opts[:conditions] = filter_str
  	end
    
    # Query
    if dscope.nil?
      # Scope model
      records = curr_model.select( sql_opts[:select] ).limit( sql_opts[:limit] ).order( sql_opts[:order] ).where( sql_opts[:conditions] ).joins(sql_opts[:joins])
      # Records Found
      filtered_total = curr_model.count( :select => "*", :conditions => sql_opts[:conditions], :joins => sql_opts[:joins] )
      # Total Found
      total = curr_model.count( :select => "*" )
    elsif params[:id].nil?  
      # Scope model
      records = curr_model.send( dscope.to_s ).select( sql_opts[:select] ).limit( sql_opts[:limit] ).order( sql_opts[:order] ).where( sql_opts[:conditions] ).joins(sql_opts[:joins])
      # Records Found
      filtered_total = curr_model.send( dscope.to_s ).count( :select => "*", :conditions => sql_opts[:conditions], :joins => sql_opts[:joins] )
      # Total Found
      total = curr_model.send( dscope.to_s ).count( :select => "*" )
    else
      # Scope model
      records = curr_model.send( dscope.to_s, params[:id] ).select( sql_opts[:select] ).limit( sql_opts[:limit] ).order( sql_opts[:order] ).where( sql_opts[:conditions] ).joins(sql_opts[:joins])
      # Records Found
      filtered_total = curr_model.send( dscope.to_s, params[:id] ).count( :select => "*", :conditions => sql_opts[:conditions], :joins => sql_opts[:joins] )
      # Total Found
      total = curr_model.send( dscope.to_s, params[:id] ).count( :select => "*" )
    end
  
    # Build Output Data Structure
  	output = { "sEcho" => params['sEcho'], 
  	           "iTotalRecords" => total,
  	           "iTotalDisplayRecords" => filtered_total,
  	           "aaData" => [] }
  
  	records.each do |a_row|
  	  row = []
  	  columns.each_with_index do |col,i|
  	    if col == "version" # Special output formatting for version column
  	      row.push( a_row[ col ]=="0" ? '-' : a_row[ col ] )
  	    elsif col != ' ' # General Output
  	      row.push( a_row[ col ])
  	    end
  	  end
  	  output['aaData'].push(row)
  	end
  	
  	output
  end
end