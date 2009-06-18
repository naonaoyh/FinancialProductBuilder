class ProcessMap
  def generateMap(phash)
    map =""
    map << "channels\n"
    map << "\tchannel :default\n"
    map << "\t\tprocesses\n"
    map << "\t\t\tworkflow_steps\n"
    phash.each do |k,v|
      map << "\t\t\t\tstep :#{k},\t\t\t\t\t {#{dodo(v[:do])}:template => :#{k},:layout => :blank}\n"
    end
    map << "\t\t\tendworkflow_steps\n"
    map << "\t\t\tvalid_flows\n"
    phash.each do |k,v|
      map << "\t\t\t\tflow :#{k},\t\t\t\t\t [#{printnav(v[:navigation])}]\n"
    end
    map << "\t\t\tendvalid_flows\n"
    map << "\t\tendprocesses\n"
    map << "\tendchannel\n"
    map
  end

  def printnav(nav_array)
    text = ""
    comma = ""
    nav_array.each do |n|
      text << comma+":#{n}"
      comma = ","
    end
    text
  end

  def dodo(do_block)
    text = ""
    if (do_block != :nothing)
      text = ":do => :#{do_block},"
    end
    text
  end

  def genLayouts(hoo,elements)
      result = Array.new
      hoo.each do |k,v|
        layout = Array.new
        layout[0] = k
        layout[1] = layoutText(k,v[:data_model],elements)
        result.push layout
      end
      result
  end

  def layoutText(k,items,elements)
    text = ""
    text << "layout 21\n"
    text << "\tcolumns\n"
    text << "\t\tcolumn 1\n"
    text << "\t\t\twidget :logo\n"
    text << "\t\t\tendwidget\n"
    text << "\t\t\twidget :page_title, {:title => :#{k}_page_title}\n"
    text << "\t\t\tendwidget \n"
    text << "\t\t\twidget :submit_panel\n"
    items.each do |i|
      text << "\t\t\t\twidget :extending_panel,{:title => :#{i}}\n"
      text << "\t\t\t\t\t#{getType(i,elements)} :#{i}\n"
      text << "\t\t\t\tendwidget \n"
    end
    text << "\t\t\twidget :button_panel\n"
    text << "\t\t\tendwidget \n"
    text << "\t\tendwidget \n"
    text << "\t\tendcolumn\n"
    text << "\tendcolumns\n"
    text << "footer\n"
    text << "endfooter\n"
    text << "endlayout\n"
    text
  end

  def getType(item,elements)
    elements.each do |e|
      if (e.name == "#{item}")
        return e.type == "entities" ? "entity" : "coverage"
      end
    end
  end
end