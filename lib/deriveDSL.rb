#!/usr/local/bin/ruby -w

# == Copyright
#
#   Copyright (c) 2007-2009 Orangery Technology Limited
#   Licensed under the same terms as Ruby.
#
# == Synopsis
# 
# A script to call high level DSL interpreters and create an IAB compliant
# repository of product level DSL from an enterprise data and process DSL model
# of the business.
# 
# In short this offers an easy way to quickly bootsrap an insurance business
# by defining products, their data models and their processes.
#
# == Usage
# 
#   ./deriveDSL.rb 'input path' 'output path' OrgName DataModel.oil SiteProcess.oil
#   

require 'rubygems'
require 'DataModelInterpreter'
require 'SiteProcessInterpreter'
require 'Element'

require 'models'
require 'processmap'
require 'productconfig'

require 'genGITstructure'
require 'rdoc/usage'

if (ARGV.length != 5)
  RDoc::usage
end

INPUT = ARGV[0]
OUTPUT = ARGV[1]
ORG = ARGV[2]
DM = ARGV[3]
SP = ARGV[4]

contents = ""
open("#{INPUT}/#{SP}") {|f| contents = f.read }
hoo = SiteProcessInterpreter.execute(contents.to_s) #hoo is an array of objects
# the array contains three child objects:-
# 0) distinct list of steps with associated navigation points, a "do" statement (if any) (a hash)
# 1) distinct list of products (an array)
# 2) distinct list of data items (a set)

tree = GenGITStructure.new
tree.makeDirTree(OUTPUT,ORG,hoo[1])

open("#{INPUT}/#{DM}") {|f| @contents = f.read }
dsl = @contents.to_s
elements = DataModelInterpreter.execute(dsl) #elements is an array of 'Element' objects

# Element structure is:-
# isacoverage? - indicates whether top level - really should be named 'top level coverage or entity?'
# name - name
# children - array elements
# parent - an element
# fields - name, type, mask
# type - coverage or entity

modelData = Models.new
resultDMFiles = modelData.generateFiles(elements)
dictionaryEntries = modelData.genDict(elements)

# create 'the library'
# these are coverage and entity definitions in a RAILS format
# exactly the same format as RAILS would generate from a relational schema
# in .../libraries/coverages
# in .../libraries/entities
resultDMFiles.each do |k,v|
  File.open(File.join(OUTPUT, ORG,'git','libraries',"#{v[3]}","#{k}DataModel.rb"), 'w') {|f| f.write(v[0]) }
  File.open(File.join(OUTPUT, ORG,'git','libraries',"#{v[3]}","#{k}NodeName.rb"), 'w') {|f| f.write(v[1]) }
  File.open(File.join(OUTPUT, ORG,'git','libraries',"#{v[3]}","#{k}PropertyHash"), 'w') {|f| f.write(v[2]) }
end

# create the product process DSL file - git/products/PRODUCT/DSL/processes.oil
# use hoo[0] to drive this
pmap = ProcessMap.new
map = pmap.generateMap(hoo[0])
File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','processes.oil'), 'w') {|f| f.write(map) }

# create layouts for each of the steps of each process
# generate to git/products/PRODUCT/DSL/layouts
# drive this from hoo[0] data since this contains steps and data usage info
layouts = pmap.genLayouts(hoo[0],elements)
layouts.each do |l|
   File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','layouts',"#{l[0]}.oil"), 'w') {|f| f.write(l[1]) }
end

# create product level manifest of coverages and entities - git/products/PRODUCT/DSL/product.oil
# for now use hoo[2] to drive this
pcfg = ProductConfig.new
cfg = pcfg.createManifest(hoo[1],elements)
File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','product.oil'), 'w') {|f| f.write(cfg) }

# create product level entities and coverages field usage files...essentially 'views' on the coverage record
# generate to git/products/PRODUCT/DSL/coverages (or /entities)
# use hoo[2] and field info from the elements object returned from DataModelInterpreter
entcov = pcfg.genViews(elements)
entcov[0].each do |fd|
  File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','coverages',"#{fd[0]}.oil"), 'w') {|f| f.write(fd[1]) }
end
entcov[1].each do |fd|
  File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','entities',"#{fd[0]}.oil"), 'w') {|f| f.write(fd[1]) }
end

# create git/products/PRODUCT/DSL/rating.oil file by simply writing out 2 hardcoded lines for the moment
rating = ""
rating << "dictionary 'XML','ShopPackageQuoteNBRq','110','100','ShopSkel100-01'\n"
rating << "rating_engine 'RTE','Response'"
File.open(File.join(OUTPUT, ORG,'git','products',"#{hoo[1]}",'DSL','rating.oil'), 'w') {|f| f.write(rating) }


# copy layout grids from lib/templates_and_resources/layouts_and_grids
# to git/libraries/genericlayoutgrids
pcfg.copyDirectoryWithoutHiddenRecursively(File.join('templates_and_resources','layouts_and_grids'),File.join(OUTPUT, ORG,'git','libraries','genericlayoutgrids','stylesheets'))

# copy lib/templates_and_resources/defaultBrand contents
# to git/brands/default
pcfg.copyDirectoryWithoutHiddenRecursively(File.join('templates_and_resources','defaultBrand'),File.join(OUTPUT, ORG,'git','brands','Default'))

pcfg.copyDirectoryWithoutHiddenRecursively(File.join('templates_and_resources','DSLTemplates'),File.join(OUTPUT, ORG,'git','libraries','DSLTemplates'))

# create dictionary file and place in git/products
# take dictionary template from lib/templates_and_resources/dictionary_en.rb
# and splice in data model specific strings by replacing string #ENTITYSPECIFIC
# use xpath to derive string name and use node name as the translation target
pcfg.copyDirectoryWithoutHiddenRecursively(File.join('templates_and_resources','dictionaries'),File.join(OUTPUT, ORG,'git','products'))
open(File.join(OUTPUT, ORG,'git','products','dictionary_en.rb'), 'r+') do |f|
  content = f.read()
  content.gsub!('#ENTITYSPECIFIC',dictionaryEntries)
  f.truncate(0)
  f.rewind()
  f.write(content)
  f.close()
end

# copy example list file into git/libraries/lists from lib/templates_and_resources/lists/PersonTitles_en.rb
# to git/libraries/lists/PersonTitles_en.rb
pcfg.copyDirectoryWithoutHiddenRecursively(File.join('templates_and_resources','lists'),File.join(OUTPUT, ORG,'git','libraries','lists'))

