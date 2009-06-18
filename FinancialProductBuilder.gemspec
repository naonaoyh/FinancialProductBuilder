# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{FinancialProductBuilder}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gary Mawdsley"]
  s.date = %q{2009-03-31}
  s.description = %q{FinancialProductBuilder is a series of scripts (and GUI) that allows new financial products to be defined}
  s.email = %q{garymawdsley@gmail.com}
  s.files = ["lib/deriveDSL.rb", "lib/productconfig.rb", "lib/processmap.rb", "lib/controllers", "lib/controllers/pbbase_controller.rb", "lib/templates_and_resources", "lib/templates_and_resources/DSLTemplates", "lib/templates_and_resources/DSLTemplates/entities", "lib/templates_and_resources/DSLTemplates/processes.oil", "lib/templates_and_resources/DSLTemplates/layouts", "lib/templates_and_resources/DSLTemplates/layouts/Errored.oil", "lib/templates_and_resources/DSLTemplates/layouts/SaveConfirm.oil", "lib/templates_and_resources/DSLTemplates/layouts/ProductSelection.oil", "lib/templates_and_resources/DSLTemplates/layouts/MTARiskDataUpdate.oil", "lib/templates_and_resources/DSLTemplates/layouts/QuoteSearch.oil", "lib/templates_and_resources/DSLTemplates/layouts/TakePayment.oil", "lib/templates_and_resources/DSLTemplates/layouts/SearchResult.oil", "lib/templates_and_resources/DSLTemplates/layouts/ConfirmPayment.oil", "lib/templates_and_resources/DSLTemplates/layouts/CancelConfirm.oil", "lib/templates_and_resources/DSLTemplates/layouts/QuoteSummary.oil", "lib/templates_and_resources/DSLTemplates/layouts/PolicySearch.oil", "lib/templates_and_resources/DSLTemplates/layouts/DeclineRefer.oil", "lib/templates_and_resources/DSLTemplates/layouts/QNBRiskDataCollect.oil", "lib/templates_and_resources/DSLTemplates/rating.oil", "lib/templates_and_resources/DSLTemplates/product.oil", "lib/templates_and_resources/DSLTemplates/coverages", "lib/templates_and_resources/defaultBrand", "lib/templates_and_resources/defaultBrand/damManifest.rb", "lib/templates_and_resources/defaultBrand/images", "lib/templates_and_resources/defaultBrand/images/hotel_teaser.jpg", "lib/templates_and_resources/defaultBrand/images/FirstCommercial.png", "lib/templates_and_resources/defaultBrand/images/star.png", "lib/templates_and_resources/defaultBrand/images/pub_teaser.jpg", "lib/templates_and_resources/defaultBrand/images/help.png", "lib/templates_and_resources/defaultBrand/images/FirstCommercialBeta.png", "lib/templates_and_resources/defaultBrand/images/information.png", "lib/templates_and_resources/defaultBrand/images/bullet_star.png", "lib/templates_and_resources/defaultBrand/images/india-flag.gif", "lib/templates_and_resources/defaultBrand/images/van_teaser.jpg", "lib/templates_and_resources/defaultBrand/images/star_hollow.png", "lib/templates_and_resources/defaultBrand/images/uk-flag.png", "lib/templates_and_resources/defaultBrand/images/tick.png", "lib/templates_and_resources/defaultBrand/images/lightbulb.png", "lib/templates_and_resources/defaultBrand/images/surgery_teaser.jpg", "lib/templates_and_resources/defaultBrand/images/FloristAdvert.jpg", "lib/templates_and_resources/defaultBrand/images/2col[1].jpg", "lib/templates_and_resources/defaultBrand/teasers", "lib/templates_and_resources/defaultBrand/teasers/travel_icon_vsmall.gif", "lib/templates_and_resources/defaultBrand/teasers/_goodDealBetter.erb", "lib/templates_and_resources/defaultBrand/teasers/splash_r_top.gif", "lib/templates_and_resources/defaultBrand/teasers/home_icon_vsmall.gif", "lib/templates_and_resources/defaultBrand/teasers/beat_a.gif", "lib/templates_and_resources/defaultBrand/teasers/car_icon_vsmall.gif", "lib/templates_and_resources/defaultBrand/teasers/beat_b.gif", "lib/templates_and_resources/defaultBrand/teasers/_crossSellPersonalLines.erb", "lib/templates_and_resources/defaultBrand/teasers/life_icon_vsmall.gif", "lib/templates_and_resources/defaultBrand/teasers/_crossSellCommercialLines.erb", "lib/templates_and_resources/defaultBrand/teasers/beat_c.gif", "lib/templates_and_resources/defaultBrand/teasers/greyarrow.gif", "lib/templates_and_resources/dictionaries", "lib/templates_and_resources/dictionaries/dictionary_en.rb", "lib/templates_and_resources/lists", "lib/templates_and_resources/lists/PersonTitles_en.rb", "lib/templates_and_resources/layouts_and_grids", "lib/templates_and_resources/layouts_and_grids/25.css", "lib/templates_and_resources/layouts_and_grids/34.css", "lib/templates_and_resources/layouts_and_grids/4.css", "lib/templates_and_resources/layouts_and_grids/LayoutGala07.css", "lib/templates_and_resources/layouts_and_grids/5.css", "lib/templates_and_resources/layouts_and_grids/24.css", "lib/templates_and_resources/layouts_and_grids/21.css", "lib/helpers", "lib/helpers/pb_helper.rb", "lib/models.rb", "lib/genGITstructure.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/iab/FinancialProductBuilder}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{FinancialProductBuilder}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{FinancialProductBuilder is a series of scripts (and GUI) that allows new financial products to be defined}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  end
end
