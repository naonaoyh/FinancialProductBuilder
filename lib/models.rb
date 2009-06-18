require 'rubygems'
require 'Element'

class Models
  def generateFiles(result)
    @result = Hash.new
    #collect statement reduces the list to a list of coverages only
    @entitycoverage = ""
    @entityModel = ""
    @nodeName = ""
    createClass((result.collect {|x| x if x.coverage}).compact)

    @entitycoverage = ""
    @propertyHash = ""
    @fieldDECs=""
    createHash((result.collect {|x| x if x.coverage}).compact)

    @result
  end

  def genDict(result)
    @distinctLabels = Hash.new
    @dictionary = ""
    createDictionaryEntries(result)
    @dictionary
  end

  # -- build entity model and propertyhashes files to plug into IAB library
  def createHash(list)
    list.each do |e|
      if (e.coverage)
        @entitycoverage = e.name
      end
      @propertyHash << "#{hashline(e)}\n"
        e.fields.each do |f|
          @propertyHash << "#{fieldline(f)}\n"
          @fieldDECs << "#{fieldDEC(e,f)}\n"
        end
      createHash(e.children) if e.children.length > 0
      if (e.coverage)
        @result[e.name.to_sym][2] = @propertyHash + @fieldDECs
        @result[e.name.to_sym][3] = e.type
        @propertyHash = ""
        @fieldDECs = ""
      end
    end
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

  def createClass(list)
    list.each do |e|
      if (e.coverage)
        @entitycoverage = e.name
      end
      @nodeName << "#{classline(e)}\n"
      nodeclauses(e.name)

      @entityModel << "#{classline(e)}\n"
      e.children.each do |c|
        @entityModel << "#{childline(c)}\n"
      end
      @entityModel << "end\n"
      @nodeName << "end\n"
      createClass(e.children) if e.children.length > 0
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
    pname =  @entitycoverage + delimiter + pname if !e.coverage
    pname
  end
end

