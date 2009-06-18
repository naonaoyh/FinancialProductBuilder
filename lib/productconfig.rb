require 'Element'

class ProductConfig
  def createManifest(product,dataelements)
    result = "product :#{product}\n"
    result << "\tcoverages\n"
    (dataelements.collect {|x| x if x.type == "coverages"}).compact.each do |e|
      result << "\t\thas_one :#{e.name}\n"
    end
    result << "\tendcoverages\n"
    result << "\tentities\n"
    (dataelements.collect {|x| x if x.type == "entities"}).compact.each do |e|
      result << "\t\thas_one :#{e.name}\n"
    end
    result << "\tendentities\n"
    result << "endproduct\n"
  end

  def genViews(dataelements)
    result = Array.new
    result[0] = Array.new
    result[1] = Array.new

    (dataelements.collect {|x| x if x.type == "coverages"}).compact.each do |e|
      text = "coverage :#{e.name}\n"
      text << getFields(e,1,e.name)
      text << "endcoverage"
      a = Array.new
      a.push e.name
      a.push text
      result[0].push a
    end

    (dataelements.collect {|x| x if x.type == "entities"}).compact.each do |e|
      text = "entity :#{e.name}\n"
      text << getFields(e,1,e.name)
      text << "endentity"
      a = Array.new
      a.push e.name
      a.push text
      result[1].push a
    end

    result
  end

  def getFields(e,depth,topLevelName)
    text = ""

    if (e.fields and e.fields.length > 0)
      e.fields.each do |f|
        ename=""
        ename = ":#{e.name}," if e.name != topLevelName
        text << "\tuse "+pname(e,",")+"#{ename}:#{f[:name]}\n"
      end
    end 
    if (e.children and e.children.length > 0)
      e.children.each do |c|
        text << getFields(c,depth+1,topLevelName)
      end
    end
    
    text
  end

   def pname(e,delimiter)
    pname = ""
    parent = e.parent
    while parent
      pname = ":" + parent.name + delimiter + pname
      parent = parent.parent
    end
    pname
  end

  def copyDirectoryWithoutHiddenRecursively(src, dest)
    # make the destination directory if it does not exist
    unless (File.directory?(dest)) then
      FileUtils.mkpath(dest)
    end
    # recursively copy files and folders without hidden files
    Dir.glob(File.join(src, '*'), File::FNM_PATHNAME) do |p|
      if (File.directory?(p))
        copyDirectoryWithoutHiddenRecursively(p, File.join(dest, File.basename(p)))
      else
        FileUtils.cp(p, dest)
      end
    end
  end
end