# Copyright (c) 2007-2009 Orangery Technology Limited
# You can redistribute it and/or modify it under the same terms as Ruby.
#
require 'Marshaller'
require 'helpers/pb_helper'

class PbBaseController < ApplicationController
  
  include Marshaller
  include PbHelper
  
  def products
    product = params['product']
    if (product != nil) then
      if (!product?(product)) then
        session[:selected_product] = nil
        session[:selected_product_item] = nil
      else
        session[:selected_product] = product
        session[:selected_product_item] = nil
      end
    end
    entity = params['entity']
    if (entity != nil) then
      session[:selected_product_item] = entity
    end
    render(:template => "pb/products", :layout => 'products')
  end
  
  def product_add
    name = params['name']
    unless (name == nil) then
      name.strip!()
      name.capitalize!()
      addProduct(name)
      session[:selected_product] = name
      session[:selected_product_item] = nil
    end
    redirect_to(:action => 'products')
  end
  
  def product_clone
    existingName = session[:selected_product]
    clonedName = params['clonedName']
    unless ((existingName == nil) || (clonedName == nil) || (clonedName.empty?())) then
      clonedName.strip!()
      clonedName = Inflector.camelize(clonedName)
      cloneProduct(existingName, clonedName)
      session[:selected_product] = clonedName
      session[:selected_product_item] = nil
    end
    redirect_to(:action => 'products')
  end
  
  def product_delete
    name = session[:selected_product]
    unless (name == nil) then
      deleteProduct(name)
      session[:selected_product] = nil
      session[:selected_product_item] = nil
    end
    redirect_to(:action => 'products')
  end
  
  def entity_add
    name = params['name']
    if (params['type'] == 'coverage') then
      type = :coverage
    else
      type = :entity
    end
    unless (name == nil) then
      addProductEntity(session[:selected_product], type, name)
    end
    render(:text => :OK)
  end
  
  def update_cardinality
    entity = params['entity']
    cardinality = params['cardinality']
    unless ((entity == nil) || (cardinality == nil)) then
      updateEntityCardinality(session[:selected_product], entity, cardinality)
    end
    render(:text => :OK)
  end

  def entity_delete
    name = params['name']
    unless (name == nil) then
      deleteProductEntity(session[:selected_product], name)
      if (session[:selected_product_item] == name) then
        session[:selected_product_item] = nil
      end
    end
    render(:text => :OK)
  end
    
  def entity_save
    entities = params['entities']
    unless (entities == nil) then
      selected = entities.split(' ');
      saveEntityDetails(session[:selected_product], session[:selected_product_item], selected.sort)
    end    
    render(:text => :OK)
  end

  def dictionary_update
    lang = session[:lang]
    id = params['id']
    value = params['value']
    if ((lang != nil) && (id != nil)) then
      updateDictionary(lang, id, value)
    end
    # render back the value to confirm change
    render(:text => value)
  end
  
  def test_drive
    # extract data from incoming params
    lang = params['lang']
    brand = params['brand']
    product = params['product']
    # the following config could be externalised if required
    port = '9000'
    edit = 'true'
    environment = 'development'
    logDir = 'log'
    pidFile = File.join(logDir, 'testdrive.pid')
    logFile = File.join(logDir, 'testdrive.log')
    if (File.exist?(logFile)) then
      FileUtils.rm(logFile)
    end
    # stop existing mongrel if there is one
    startCmd = "source ~/.bash_profile;mongrel_rails start  --daemonize --port #{port} --environment #{environment} --log #{logFile} --pid #{pidFile}"
    stopCmd = "mongrel_rails stop --pid #{pidFile}"
    restartCmd = "mongrel_rails restart --pid #{pidFile}"
    if (File.exist?(pidFile)) then
      cmd = restartCmd
    else
     cmd = startCmd
    end
    system(cmd)
    sleep(1)
    puts "Executed Mongrel command [#{cmd}] see log file [#{logFile}] for further details\n"
    # send back the url for test driving
    url = "http://127.0.0.1:#{port}/iab/QNBRiskDataCollect?brand=#{brand}&product=#{product}&lang=#{lang}&edit=#{edit}"
    puts "Returned URL for test drive [#{url}]"
    render(:text => url)
  end

  def update_mandatory
    puts 'PLEASE WRITE ME'
    render(:text => :OK)
  end
end
