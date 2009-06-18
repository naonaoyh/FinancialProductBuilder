# Copyright (c) 2007-2008 Orangery Technology Limited 
# You can redistribute it and/or modify it under the same terms as Ruby.
#
module DefaultManifest
  def associateDAMReferences
    @logo = "#{BRANDS_EXT}/Default/images/FirstCommercialBeta.png"
    # these two are from carousel
    @newBusiness = "new quote"
    @quoteSearch = "quote search"
    
    # single line row widget images
    @mandatoryIcon = "#{BRANDS_EXT}/Default/images/star.png"
    @tickIcon = "#{BRANDS_EXT}/Default/images/tick.png"
    @helpIcon = "#{BRANDS_EXT}/Default/images/information.png"

    #teaser images
    @van_teaser = "#{BRANDS_EXT}/Default/images/van_teaser.jpg"
    @pub_teaser = "#{BRANDS_EXT}/Default/images/pub_teaser.jpg"
    @hotel_teaser = "#{BRANDS_EXT}/Default/images/hotel_teaser.jpg"
    @surgery_teaser = "#{BRANDS_EXT}/Default/images/surgery_teaser.jpg"
    
    #images
    @florist_ad = "#{BRANDS_EXT}/Default/images/FloristAdvert.jpg"
    
    # css references
    @buttonPanelCss = "#{LIBRARY_EXT}/widgets/button_panel/button_panel.css"
    @carouselCss = "#{LIBRARY_EXT}/widgets/carousel/carousel.css"
    @dateInputCss = "#{LIBRARY_EXT}/widgets/date_input/date_input.css"
    @descriptionInputCss = "#{LIBRARY_EXT}/widgets/description_input/description_input.css"
    @extendingPanelCss = "#{LIBRARY_EXT}/widgets/extending_panel/extending_panel.css"
    @flipCss = "#{LIBRARY_EXT}/widgets/flip/flip.css"
    @legalNoticeCss = "#{LIBRARY_EXT}/widgets/legal_notice/legal_notice.css"
    @narrationTextCss = "#{LIBRARY_EXT}/widgets/narration_text/narration_text.css"
    @pageTitleCss = "#{LIBRARY_EXT}/widgets/page_title/page_title.css"
    @premiumCss = "#{LIBRARY_EXT}/widgets/premium/premium.css"
    @productListCss = "#{LIBRARY_EXT}/widgets/product_list/product_list.css"
    @progressBarCss = "#{LIBRARY_EXT}/widgets/progress_bar/progress_bar.css"
    @singleLineRowPanelCss = "#{LIBRARY_EXT}/widgets/singleline_rowpanel/singleline_rowpanel.css"
    @sitemapCss = "#{LIBRARY_EXT}/widgets/sitemap/sitemap.css"
    @slidingMenuCss = "#{LIBRARY_EXT}/widgets/sliding_menu/sliding_menu.css"
    @teaserCss = "#{LIBRARY_EXT}/widgets/teaser/teaser.css"

    # js references
    @carouselJs = "#{LIBRARY_EXT}/widgets/carousel/carousel.js"
    @dateInputJs = "#{LIBRARY_EXT}/widgets/date_input/date_input.js"
    @descriptionInputJs = "#{LIBRARY_EXT}/widgets/description_input/description_input.js"
    @extendingPanelJs = "#{LIBRARY_EXT}/widgets/extending_panel/extending_panel.js"
    @flipJs = "#{LIBRARY_EXT}/widgets/flip/flip.js"
    @numberInputJs = "#{LIBRARY_EXT}/widgets/number_input/number_input.js"
    @premiumJs = "#{LIBRARY_EXT}/widgets/premium/premium.js"
    @singleLineRowPanelJs = "#{LIBRARY_EXT}/widgets/singleline_rowpanel/singleline_rowpanel.js"
    @slidingMenuJs = "#{LIBRARY_EXT}/widgets/sliding_menu/sliding_menu.js"
    @textInputJs = "#{LIBRARY_EXT}/widgets/text_input/text_input.js"
  end

  def productName(product)
    return "not used"
  end

  def productTitle(product)
    return "not used"
  end
end