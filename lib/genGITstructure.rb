require 'fileutils'

include FileUtils

class GenGITStructure
  def makeDirTree(*args)
    output = args[0]
    org = args[1]
    productNames = args[2]

    dir = ""
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','brands'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries','coverages'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries','entities'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries','genericlayoutgrids'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries','genericlayoutgrids','stylesheets'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','libraries','lists'))
    Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products'))

    productNames.each do |p|
      Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products',"#{p}"))
      Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products',"#{p}",'DSL'))
      Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products',"#{p}",'DSL','coverages'))
      Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products',"#{p}",'DSL','entities'))
      Dir.mkdir(dir) if !File.exist?(dir = File.join(output, org,'git','products',"#{p}",'DSL','layouts'))
    end
  end
end