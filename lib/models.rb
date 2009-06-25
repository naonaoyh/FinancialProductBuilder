require 'rubygems'
require 'Element'

class Models
  def generateFiles(result)
    list = (result.collect {|x| x if x.coverage}).compact
    @result = Hash.new
    #collect statement reduces the list to a list of coverages only
    @entitycoverage = ""
    @entityModel = ""
    @nodeName = ""
    createClass(nil,list)

    @entitycoverage = ""
    @propertyHash = ""
    @fieldDECs=""
    createHash(nil,list)

    @result
  end

  def genDict(result)
    @distinctLabels = Hash.new
    @dictionary = ""
    #createDictionaryEntries(result)
    @dictionary
  end

  # -- build entity model and propertyhashes files to plug into IAB library
  def createHash(parent,list)
    list.each do |e|
      e.parent = parent if parent
      if (e.coverage)
        @entitycoverage = e.name
      end
      @propertyHash << "#{hashline(e)}\n"
        e.fields.each do |f|
          @propertyHash << "#{fieldline(f)}\n"
          @fieldDECs << "#{fieldDEC(e,f)}\n"
        end
      createHash(e,e.children) if e.children.length > 0
      if (e.coverage)
        @result[e.name.to_sym][2] = @propertyHash + @fieldDECs
        @result[e.name.to_sym][3] = e.type
        @propertyHash = ""
        @fieldDECs = ""
      end
    end
  end

  def hashline(e)
    "#{pname(e)}#{e.name}: !map:HashWithIndifferentAccess\n  xpath: \"#{pname2(e,'/')}#{e.name}\""
  end
  def fieldline(f)
    mask = f[:mask] ? "\n    mask: \"#{f[:mask]}\"" : ""
    "  #{f[:name]}: \"\"\n  #{f[:name]}MD: !map:HashWithIndifferentAccess\n    type: \"#{f[:stype]}\"#{mask}"
  end
  def fieldDEC(e,f)
    "#{pname(e)}#{e.name}#{f[:name]}: !map:HashWithIndifferentAccess\n  xpath: \"#{pname2(e,'/')}#{e.name}/#{f}\""
  end

  def createClass(parent,list)
    list.each do |e|
      e.parent = parent if parent
      if (e.coverage)
        @entitycoverage = e.name
      end
      #build up the node name clauses
      @nodeName << "#{classline(e)}\n"
      nodeclauses(e.name)

      @entityModel << "#{classline(e)}\n"
      #puts "classline for #{e.name} is #{classline(e)}"
      #iterate around the children and build the entity model
      e.children.each do |c|
        c.parent = e
        @entityModel << "#{childline(c)}\n"
      end
      @entityModel << "end\n"
      @nodeName << "end\n"

      #now take the children in turn
      createClass(e,e.children) if e.children.length > 0
      if (e.coverage)
        @result[e.name.to_sym] = []
        @result[e.name.to_sym][0] = @entityModel
        @result[e.name.to_sym][1] = @nodeName
        @result[e.name.to_sym][3] = e.type
        @entityModel = ""
        @nodeName = ""
      end
    end
  end

  def nodeclauses(n)
    @nodeName << "\t@@nodeName = \"#{n}\"\n"
    @nodeName << "\tdef self.nodeName\n"
    @nodeName << "\t@@nodeName\n"
    @nodeName << "\tend\n"
  end

  def classline(e)
    "class #{pname(e)}#{e.name} < ActiveRecord::Base"
  end
  def childline(c)
    "has_one :#{pname(c)}#{c.name}"
  end

  def pname(e)
    pname2(e,"")
  end

  def pname2(e,delimiter)
    pname = ""
    parent = e.parent
    while parent
      pname = parent.name + delimiter + pname
      parent = parent.parent
    end
    pname =  pname if !e.coverage
    pname
  end

  def createDictionaryEntries(list)
    list.each do |e|
      fieldPrefix = "'#{pname(e)}#{e.name}".downcase
      e.fields.each do |f|
        key = "#{pname(e)}#{e.name}#{f[:name]}"
        if !@distinctLabels.has_key?(key.to_sym)
          @dictionary << "\t\t\t#{fieldPrefix}_#{f[:name].downcase}' => '#{f[:name]}',\n"
          @distinctLabels[key.to_sym] = 1
        end
      end
      createDictionaryEntries(e.children) if e.children.length > 0
    end
  end
end

