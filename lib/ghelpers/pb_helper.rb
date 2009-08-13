# Copyright (c) 2007-2009 Orangery Technology Limited
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'fileutils'
require 'ProductInterpreter'
require 'CoverageInterpreter2'
require 'ProductInterpreter2'
require 'channel_manager'

module PbHelper

  include FileUtils
  include ChannelManager

  def product?(name)
    if ((name != nil) && (!name.empty?()) && File.directory?(File.join(PRODUCTS_ROOT, name))) then
      # TODO: add code here to perform a validation of the product
      # Possible steps:
      # 1. Check there is a product.oil
      # 2. Check that each entity and coverage in product.oil has a valid entity/coverage oil file
      # 3. Ensure all items are in the library etc.
      # .... loads of other stuff
      return true
    end
    return false
  end

  def getProducts
    products = Array.new
    Dir.glob(File.join(PRODUCTS_ROOT, '*'), File::FNM_PATHNAME) do |p|
      if File.directory?(p)
        products.push(File.basename(p))
      end
    end
    products.sort
  end
  
  def getLanguages
    languages = Array.new
    Dir.glob(File.join(PRODUCTS_ROOT, 'dictionary_*.rb'), File::FNM_PATHNAME) do |p|
      languages.push(File.basename(p).sub(/dictionary_(.\w+)\.rb/, '\1'))
    end
    languages.sort
  end
  
  def getBrands
    brands = Array.new
    Dir.glob(File.join(BRANDS_ROOT, '*'), File::FNM_PATHNAME) do |p|
      if File.directory?(p)
        brands.push(File.basename(p))
      end
    end
    brands.sort
  end
  
  def addProduct(name)
    productDirectory = File.join(PRODUCTS_ROOT, name)
    # create the new product directory
    Dir.mkdir(productDirectory)
    # create the DSL folder
    productDSLDirectory = File.join(productDirectory, 'DSL')
    Dir.mkdir(productDSLDirectory)
    # copy the DSL template directory
    copyDirectoryWithoutHiddenRecursively(PRODUCT_DSL_TEMPLATE_ROOT, productDSLDirectory)
    # update product.oil to put in the produt name
    findAndReplaceInFile(File.join(productDirectory, 'DSL', 'product.oil'), /#\$PRODUCT_NAME\$/, name)
  end
  
  def cloneProduct(existingProductName, newProductName)
    existingProductDirectory = File.join(PRODUCTS_ROOT, existingProductName)
    newProductDirectory = File.join(PRODUCTS_ROOT, newProductName)
    # copy the product in its entirety
    copyDirectoryWithoutHiddenRecursively(existingProductDirectory, newProductDirectory)
    # update the main oil files
    findAndReplaceInFile(File.join(newProductDirectory, 'DSL', 'product.oil'), /(\s+:)#{existingProductName}/, "\\1#{newProductName}")
  end
  
  def deleteProduct(name)
    FileUtils.mv(File.join(PRODUCTS_ROOT, name), File.join(PRODUCTS_ROOT, '.' + name))
  end
  
  def getProductEntities(product, type)
    open(File.join(PRODUCTS_ROOT, product, 'DSL','product.oil')) do |f|
      product = ProductInterpreter2.execute(f.read())
      f.close()
    end
    product.method(type).call().sort()
  end
 
  def addProductEntity(product, type, name)
    # add the coverage to product.oil
    # and ...
    # create the new coverage oil file
    if (type == :coverage) then
      findAndReplaceInFile(File.join(PRODUCTS_ROOT, product, 'DSL', 'product.oil'), /(\s+endcoverages)/, "\n   has_one :#{name}\\1")
      f = File.new(File.join(PRODUCTS_ROOT, product, 'DSL', 'coverages', name + '.oil'), 'w+')
      regex = /(\s+#\$COVERAGES\$)/
    else
      findAndReplaceInFile(File.join(PRODUCTS_ROOT, product, 'DSL', 'product.oil'), /(\s+endentities)/, "\n   has_one :#{name}\\1")
      f = File.new(File.join(PRODUCTS_ROOT, product, 'DSL', 'entities', name + '.oil'), 'w+')
      regex = /(\s+#\$ENTITIES\$)/
    end
    # some coverages and entities are essential, lets find them now
    recommendedSelections = getDefaultSelections(name, type, nil, nil)
    f.chmod(0644)
    oil = <<OIL
#{type} :#{name}
#{recommendedSelections}
end#{type}
OIL
    f.write(oil);
    f.close()
    # scan the layout oils and add this entity/coverage if required in the markup
    Dir.glob(File.join(PRODUCTS_ROOT, product, 'DSL', 'layouts', '*.oil')) do |lf|
      findAndReplaceInFile(lf, regex, "\n                #{type} :#{name}\\1")
    end
  end

  def getDefaultSelections(entity, type, recommendedSelections, path)
    if (recommendedSelections == nil) then
      recommendedSelections = ''
      loadLibraryEntity(entity, type)
      @hash = getPropertyHash(type, entity)
      path = Array.new
      path.push(entity)
    else
      path.push(entity.sub(/#{path.join()}/, ''))
    end
    c = eval(entity)
    associations = c.reflect_on_all_associations()
    associations.each do |a|
      className = a.name.id2name
      klass = eval(className)
      # see if this entity is defined as essential in the property hash
      sectionName = "#{className}MD"
      section = @hash[sectionName]
      if (section != nil) then
        value = @hash[sectionName]['usebydefault']
      end
      # puts "Entity [#{className}] value [#{value}]\n"
      if (value == 'true') then
        recommendedSelections << '     use '
        path.push(klass.nodeName)
        path.each do |t|
          unless t == path.first
            recommendedSelections << ':'
            recommendedSelections << t
            unless (t.object_id() == path.last.object_id())
              recommendedSelections << ','
            end
          end
        end
        path.pop()
        recommendedSelections << "\n"
      end
      getDefaultSelections(className, type, recommendedSelections, path)
      path.pop()
    end unless (associations.empty?())
    recommendedSelections
  end
  
  def deleteProductEntity(product, entity)
    # remove the entry from product.oil
    productOilFile = File.join(PRODUCTS_ROOT, product, 'DSL', 'product.oil')
    cardinalityMatch = '((' + getCardinalities().join(')|(') + '))'
    findAndReplaceInFile(productOilFile, /^\s*#{cardinalityMatch}\s*:\s*#{entity}\s*\n/, '')
    # delete the specific oil file
    fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'coverages', "#{entity}.oil")
    unless (File.exists?(fileName)) then
      fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'entities', "#{entity}.oil")
    end
    FileUtils.rm(fileName, :force => true)
    # remove references from layout files
    Dir.glob(File.join(PRODUCTS_ROOT, product, 'DSL', 'layouts', '*.oil'), File::FNM_PATHNAME) do |c|
      # NOTE: entities and coverages can obviously have instructions bounded in {} after them
      # e.g. title, hide etc.etc. so we need to make sure our search is fuzzy enough
      # At this stage I have elected to just look for :Entity in any line and kill the line
      findAndReplaceInFile(c, /^.*?:#{entity}.*?\n/, '')
    end
  end
  
  def updateEntityCardinality(product, entity, cardinality)
    fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'product.oil')
    findAndReplaceInFile(fileName, /(^\s+)[^\s]+(\s*:#{entity})/, "\\1#{cardinality}\\2")
  end
  
  def saveEntityDetails(product, entity, selections)
    # assert type as coverage and if the file doesn't exist assume entity
    type = :coverage
    fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'coverages', "#{entity}.oil")
    unless (File.exists?(fileName)) then
      type = :entity
      fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'entities', "#{entity}.oil")
    end
    open(fileName, 'w') do |f|
      f << "#{type} :" << entity << "\n"
      selections.each do |s|
        f << '    use ' << s << "\n"
      end
      f << "end#{type}"
      f.close()
    end
  end

  def getLibraryEntities(type)
    if (type == :coverage) then
      root = COVERAGE_DEF_ROOT
    else
      root = ENTITY_DEF_ROOT
    end
    entities = Array.new
    Dir.glob(File.join(root, '*PropertyHash'), File::FNM_PATHNAME) do |c|
      entities.push(File.basename(c.to_s).gsub(/(.*)PropertyHash/, '\1'))
    end
    entities.sort
  end
  
  def getEntityDetails(product, entity)
    # find the definition of this coverage in this product, could be entity or coverage
    fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'coverages', "#{entity}.oil")
    type = :coverage
    unless (File.exists?(fileName)) then
      fileName = File.join(PRODUCTS_ROOT, product, 'DSL', 'entities', "#{entity}.oil")
      type = :entity
    end
    # get the library definition of the coverage
    lcd = walkLibraryEntity(entity, type, nil)
    # go through all the items in the oil file that have been used and "check" them
    open(fileName) do |f|
      CoverageInterpreter2.execute(f.read).each do |s|
        lcd = lcd.gsub(/(\sname=\"#{s}\")/, '\1 checked="checked"')
      end
    end
    # puts lcd
    lcd
  end
  
  def getCardinalities()
    cardinalities = ['has_one', 'has_many']
    cardinalities
  end
  
  def updateDictionary(lang, key, value)
    open(File.join(PRODUCTS_ROOT, "dictionary_#{lang}.rb"), 'r+') do |f|
      content = f.read()
      # is the string already in the dictionary?
      if (content.match(/^\s+\"#{key}\"\s+=>\s+\"[^\"]*\"\s*,/) != nil) then
        puts "Updating dictionary: Language[#{lang}] key [#{key}] value [#{value}]\n"
        content.gsub!(/(^\s+\"#{key}\"\s+=>\s+\")[^\"]*(\"\s*,)/, "\\1#{value}\\2")
      else
        puts "Adding to dictionary: Language[#{lang}] key [#{key}] value [#{value}]\n"
        newEntry = "\n      \"#{key}\" => \"#{value}\","
        # add the new lookup at the start of the dictionary
        content.gsub!(/(^\s*def\s+dictionary\s*\n\s*\{)/, "\\1#{newEntry}")
      end
      f.truncate(0)
      f.rewind()
      f.write(content)
      f.close()

    end
  end
  
  def walkLibraryEntity(entity, type, path)
    introduce_dictionary(PRODUCTS_ROOT, 'en')
    if (path == nil) then
      loadLibraryEntity(entity, type)
      path = Array.new
      path.push(entity)
    else
      path.push(entity.sub(/#{path.join()}/, ''))
    end
    result = ''
    associations = eval(entity).reflect_on_all_associations()
    #don't render markup if there's nothing there
    unless(associations.empty?) then
      result << '<ul>' << "\n"
      associations.each do |a|
        className = a.name.id2name
        result << '<li>' << '<input type="checkbox" name="'
        nodeName = eval(className).nodeName
        path.push(nodeName)
        path.each do |t|
          unless t == path.first
            result << ':' << t
            unless (t.object_id() == path.last.object_id())
              result << ','
            end
          end
        end
        path.pop()
        result << '"/>' << '<a>' << nodeName << '</a>'
        #  try and do a lookup on the dictionary
        dictionaryKey = (entity + '_' + nodeName).downcase()
        dictionaryTranslation = __(dictionaryKey)
        if (dictionaryTranslation != dictionaryKey) then
          result << '<p><small><i>' << dictionaryTranslation << '</i></small></p>'
        end
        result << walkLibraryEntity(className, type, path) << '</li>'
        path.pop()
      end
      result << '</ul>'
    end
    result
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
  
  def loadLibraryEntity(entity, type)
    # now its time to dynamically load the the entity and its children from the library
    if (type == :coverage) then
      libraryPath = COVERAGE_DEF_ROOT
    else
      libraryPath = ENTITY_DEF_ROOT
    end
    require(File.join(libraryPath, entity + 'EntityModel.rb'))
    require(File.join(libraryPath, entity + 'NodeName.rb'))
  end
  
  def getPropertyHash(type, entity)
    if (type == :coverage) then
      libraryPath = COVERAGE_DEF_ROOT
    else
      libraryPath = ENTITY_DEF_ROOT
    end
    return YAML::load(open(File.join(libraryPath, entity + 'PropertyHash'), 'r'))
  end
  
  def findAndReplaceInFile(fileName, findExpression, replaceExpression)
    open(fileName, 'r+') do |f|
      content = f.read()
      content.gsub!(findExpression, replaceExpression)
      f.truncate(0)
      f.rewind()
      f.write(content)
      f.close()
    end
  end
end
