
# Copyright (c) 2007-2008 Orangery Technology Limited
# You can redistribute it and/or modify it under the same terms as Ruby. #

module DictionaryenHL
  def associateHLReferences
    #language strings
    @title = "Motor Trade"
    @login = "Login"
    @loginTitle = "Login"
    @paymentTitle = "Payment Details"
    @policyDocTitle = "Policy Documents"
    @username = "Username"
    @password = "Password"
    @riskText = "Call Centre only - view geocode risk"
    @welcomeTitle = "Welcome First Broker"
    @recentPolicies = "Recent Quotes and Policies"
  end

  def dictionary
    {
      # standard strings used across insurance apps

      "van_teaser_title" => "MONKEY INSURANCE",
      "True" => "True",
      "False" => "False",
      "MTA" => "MTA",

      #Inline narrative
      "legal_notice" => "Commercial insurance products are underwritten by First Commercial Insurance plc which is authorised and regulated by the Financial Services Authority. Registered office: 1 Infinite Loop, Henley On Thames, Oxon RG9 1SB. Registered in England and Wales no. 554667. The Financial Services Authority's Register can be accessed through <a href=http://www.fsa.gov.uk/register>www.fsa.gov.uk</a>",
      "risk_data_collect_intro" => "<p> Clicking any of the <img src=\"#{@helpIcon}\" alt=\"?\" /> buttons will bring <b>Help </b> text below the question. For information entered incorrectly, a <b> red error panel </b> appears below the questions that requires your attention with text explaining the error(s). Once the information has been correctly entered, you will see a <img src=\"#{@tickIcon}\" alt=\"Tick\" /> automatically next to the questions that have been completed </p>",
      "valid_twelve_months" => "Your policy will be valid for 12 months from the start date.",
      "no_insurance_declined_title" => "Declaration",
      "no_insurance_declined" => "Neither You, nor Your Directors nor Your partners have ever had a proposal for insurance declined, renewal refused, cover terminated, increased premium required or special conditions imposed by any Insurer ",
      "terms_and_conditions_title" => "Terms & Conditions",
      "terms_and_conditions" => "THIS QUOTATION IS VALID FOR THIRTY DAYS FROM TODAY'S DATE. THIS QUOTE IS SUBJECT TO SECURITY LEVEL 1 REQUIREMENTS.",
      "payment_intro_text" => "Payment can be made by a valid <b> Credit or Debit Card </b> using our secure online payment system",
      "Payment Confirm: Thank you - Links to policy doc pdfs" => "<b> Thank You <b>. Payment has been confirmed. Your policy documents will be sent to the supplied contact address within 5 working days. You can download your documents now by following the link http//sys1003006743/ret10002456/nbdoc/10001",
      "summary" => "This page is a summary of the details you have entered. Please check the information provided is correct. Once you are satisfied then please progress to the next step",

      #Buttons
      "Home" => "To Dashboard",

      "QNBRiskDataCollect1" => "New Quote",
      "QNBRiskDataCollect2" => "Continue",
      "QNBRiskDataCollect3" => "Continue",
      "QNBRiskDataCollect4" => "Continue",
      "QNBRiskDataCollect5" => "Continue",
      "QNBRiskDataCollect6" => "Continue",
      "QNBSummary" => "Quote Me",

      "PolicyQuoteSearch" => 'Search',
      "CancelConfirm" => "Quit",
      "SaveConfirm" => "Save",

      'SystemUser' => 'Log into your acount:',

      'Login_page_title' => 'Log into your acount:',
      'Home_page_title' => 'Dashboard',
      'QNBRiskDataCollect1_page_title' => 'Client Details',
      'QNBRiskDataCollect2_page_title' => 'Driver Details',
      'QNBRiskDataCollect3_page_title' => 'Vehicle Information',
      'QNBRiskDataCollect4_page_title' => 'General Information',
      'QNBRiskDataCollect5_page_title' => 'Owner',
      'QNBRiskDataCollect6_page_title' => 'Optionals',
      'QNBSummary_page_title' => 'Your Quote',
      'CancelConfirm_page_title' => "Are you sure you wish to exit?",
      'TakePayment_page_title' => "Payment Confirmed",
      'PrintDocumentation_page_title' => "Download Documentation",

      'search_page_title' => 'SEARCH',
      'search_panel_title' => 'QUOTE SEARCH',
      'search_panel_text' => 'Please enter some information from your quote',

      'search_results_page_title' => 'SEARCH',
      'search_results_panel_title' => 'SEARCH RESULTS',
      'search_results_panel_text' => 'The following quotes match your search criteria',

      'save_confirm_page_title' => 'SAVE',
      'save_confirm_panel_title' => 'SAVE CONFIMATION',
      'save_confirm_panel_text' => 'Your quote has been saved for you to complete later',

      'error_page_title' => 'ERROR',
      'error_panel_title' => 'ERROR MESSAGE',
      'error_panel_text' => 'Sorry - We are experiencing problems with our online service at the moment. Please try again a little later or call us on 0800 555 4444.',

      'decline_page_title' => 'QUOTE',
      'decline_panel_title' => 'QUOTE REFERAL ',
      'decline_panel_text' => 'We are unable to provide you with a quote online, please call us on 0800 555 4455 ',

      'confirm_payment_page_title' => 'PAYMENT',
      'confirm_payment_panel_title' => 'PAYMENT CONFIRMATION ',
      'confirm_payment_panel_text' => 'Thank you - we have successfully processes your payment.',

      'cancel_confirm_page_title' => 'CANCELLATION',
      'cancel_confirm_panel_title' => 'CANCELLATION CONFIRMATION',
      'cancel_confirm_panel_text' => 'Thank you for using the site, sorry to see you go.',

      #TEASERS
      #Van Teaser
      'van_teaser_title' => "Van Insurance",
      'van_teaser_text' => "Insure your van with us too and automatically qualify for a 25% discount",
      #Pub Teaser
      'pub_teaser_title' => 'Pub & Restaurant',
      'pub_teaser_text' => "Pub & Restaurant insurance to suit all shapes and sizes",
      #Hotel Teaser
      'hotel_teaser_title' => 'Hotel Insurance',
      'hotel_teaser_text' => "Hotel insurance to suit all shapes and sizes",
       #Surgery Teaser
      'surgery_teaser_title' => 'Office and Surgery',
      'surgery_teaser_text' => "Office and surgery insurance to suit all shapes and sizes",

      #these are the strings specific for the coverages that have been chosen for this organisation
      #ENTITYSPECIFIC
    }
  end
end
