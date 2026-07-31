// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get whatsPoppin => 'HELP मा के हुँदैछ?';

  @override
  String get soldOut => 'बिक्री भयो';

  @override
  String get full => 'पूर्ण';

  @override
  String seatsLeft(String seats) {
    return '$seats बाँकी';
  }

  @override
  String fromNpr(String price) {
    return 'NPR $price बाट सुरु';
  }

  @override
  String get admin => 'प्रशासक';

  @override
  String get organizer => 'आयोजक';

  @override
  String get attendee => 'सहभागी';

  @override
  String get weak => 'कमजोर';

  @override
  String get fair => 'ठिकै';

  @override
  String get good => 'राम्रो';

  @override
  String get strong => 'बलियो';

  @override
  String passwordStrength(String label) {
    return 'पासवर्डको बल: $label';
  }

  @override
  String get changeDefaultPasswordPrompt =>
      'अगाडि बढ्न आफ्नो पूर्वनिर्धारित पासवर्ड परिवर्तन गर्नुहोस्।';

  @override
  String get appTitle => 'Eventopia';

  @override
  String get welcomeBack => 'पुनः स्वागत छ!';

  @override
  String get back => 'पछाडि';

  @override
  String get toggleVisibility => 'पासवर्ड देखाउनुहोस्/लुकाउनुहोस्';

  @override
  String get loginToContinue => 'अगाडि बढ्न लगइन गर्नुहोस्';

  @override
  String get emailAddress => 'इमेल ठेगाना';

  @override
  String get emailIsRequired => 'इमेल आवश्यक छ';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordIsRequired => 'पासवर्ड आवश्यक छ';

  @override
  String get forgotPassword => 'पासवर्ड भुल्नुभयो?';

  @override
  String get logIn => 'लग इन';

  @override
  String get dontHaveAccount => 'खाता छैन? ';

  @override
  String get createAccountTitle => 'खाता खोल्नुहोस्';

  @override
  String get joinEventopia => 'Eventopia मा सामेल हुनुहोस्';

  @override
  String get registeringAs => 'यस रूपमा दर्ता गर्दै: ';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get fullNameIsRequired => 'पूरा नाम आवश्यक छ';

  @override
  String get nameIsTooShort => 'नाम धेरै छोटो छ';

  @override
  String get enterValidEmail => 'मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस्';

  @override
  String get phoneNumber => 'फोन नम्बर';

  @override
  String get phoneIsRequired => 'फोन नम्बर आवश्यक छ';

  @override
  String get enterValidPhone => 'मान्य फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get minimumSixChars => 'न्यूनतम ६ वर्णहरू';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get pleaseConfirmPassword => 'कृपया आफ्नो पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get passwordsDoNotMatch => 'पासवर्डहरू मेल खाँदैनन्';

  @override
  String get alreadyHaveAccount => 'पहिले नै खाता छ?  ';

  @override
  String get signIn => 'साइन इन गर्नुहोस्';

  @override
  String get home => 'गृह';

  @override
  String get users => 'प्रयोगकर्ताहरू';

  @override
  String get events => 'कार्यक्रमहरू';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get eventRequests => 'कार्यक्रम अनुरोधहरू';

  @override
  String get noPendingRequests => 'कुनै विचाराधीन अनुरोधहरू छैनन्';

  @override
  String byOrganizer(String organizer) {
    return '$organizer द्वारा';
  }

  @override
  String get eventRejected => 'कार्यक्रम अस्वीकृत गरियो';

  @override
  String get reject => 'अस्वीकार गर्नुहोस्';

  @override
  String get eventApproved => 'कार्यक्रम स्वीकृत गरियो';

  @override
  String get approve => 'स्वीकृत गर्नुहोस्';

  @override
  String get noUserLoggedIn => 'कुनै प्रयोगकर्ता लगइन भएको छैन';

  @override
  String get administrator => 'प्रशासक';

  @override
  String get organisers => 'आयोजकहरू';

  @override
  String get attendees => 'सहभागीहरू';

  @override
  String get revenue => 'राजस्व';

  @override
  String nprRevenue(String revenue) {
    return 'NPR $revenue';
  }

  @override
  String get quickActions => 'द्रुत कार्यहरू';

  @override
  String get addOrganiser => 'आयोजक\nथप्नुहोस्';

  @override
  String get eventRequestsQuickAction => 'कार्यक्रम\nअनुरोधहरू';

  @override
  String get reports => 'रिपोर्टहरू';

  @override
  String get allEvents => 'सबै कार्यक्रमहरू';

  @override
  String get seeAll => 'सबै हेर्नुहोस्';

  @override
  String get auditoriumOccupancy => 'सभागृहको उपस्थिति';

  @override
  String seatsBooked(String booked, String total) {
    return '$booked / $total सिटहरू बुक गरियो';
  }

  @override
  String get myProfile => 'मेरो प्रोफाइल';

  @override
  String get editProfile => 'प्रोफाइल सम्पादन गर्नुहोस्';

  @override
  String get name => 'नाम';

  @override
  String get phone => 'फोन';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get pleaseFillAllFields => 'कृपया सबै क्षेत्रहरू भर्नुहोस्';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल सफलतापूर्वक अद्यावधिक भयो';

  @override
  String get save => 'बचत गर्नुहोस्';

  @override
  String get email => 'इमेल';

  @override
  String get resetPassword => 'पासवर्ड रिसेट';

  @override
  String get newPassword => 'नयाँ पासवर्ड';

  @override
  String get passwordChangedSuccessfully => 'पासवर्ड सफलतापूर्वक परिवर्तन भयो';

  @override
  String get update => 'अद्यावधिक गर्नुहोस्';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get eventopiaAnalytics => 'Eventopia विश्लेषण';

  @override
  String get report => 'रिपोर्ट';

  @override
  String get eventDetails => 'कार्यक्रमको विवरण';

  @override
  String nameDetail(String name) {
    return 'नाम: $name';
  }

  @override
  String dateDetail(String date) {
    return 'मिति: $date';
  }

  @override
  String organizerDetail(String organizer) {
    return 'आयोजक: $organizer';
  }

  @override
  String locationDetail(String location) {
    return 'स्थान: $location';
  }

  @override
  String get kpi => 'मुख्य प्रदर्शन सूचकहरू';

  @override
  String get metric => 'मेट्रिक';

  @override
  String get value => 'मान';

  @override
  String get totalTicketsSold => 'कुल टिकट बिक्री';

  @override
  String get totalRevenue => 'कुल राजस्व';

  @override
  String get occupancyRate => 'उपस्थिति दर';

  @override
  String occupancyProgress(String title, String percent) {
    return '$title को उपस्थिति $percent%';
  }

  @override
  String get availableSeats => 'उपलब्ध सिटहरू';

  @override
  String get salesByTicketCategory => 'टिकट श्रेणी अनुसार बिक्री';

  @override
  String get category => 'श्रेणी';

  @override
  String get ticketsSold => 'टिकट बिक्री भयो';

  @override
  String generatedOnBySystem(String date) {
    return 'Eventopia प्रणाली द्वारा $date मा उत्पन्न';
  }

  @override
  String failedToGeneratePdf(String error) {
    return 'PDF उत्पन्न गर्न विफल: $error';
  }

  @override
  String get reportsAndAnalytics => 'रिपोर्ट र विश्लेषण';

  @override
  String get noEventsToShowAnalytics =>
      'विश्लेषण देखाउन कुनै कार्यक्रमहरू उपलब्ध छैनन्।';

  @override
  String get selectEvent => 'कार्यक्रम चयन गर्नुहोस्';

  @override
  String ofTotal(String total) {
    return '$total कुल मध्ये';
  }

  @override
  String get occupancy => 'उपस्थिति';

  @override
  String get available => 'उपलब्ध';

  @override
  String get sevenDayRevenue => '७-दिनको राजस्व';

  @override
  String get salesByCategory => 'श्रेणी अनुसार बिक्री';

  @override
  String get passwordChangedPleaseLogin =>
      'पासवर्ड सफलतापूर्वक परिवर्तन भयो। कृपया लगइन गर्नुहोस्।';

  @override
  String get changePassword => 'पासवर्ड परिवर्तन गर्नुहोस्';

  @override
  String get enterNewPasswordDesc =>
      'आफ्नो खाता सुरक्षित गर्न तल नयाँ पासवर्ड प्रविष्ट गर्नुहोस्।';

  @override
  String entryApprovedFor(String title) {
    return '\"$title\" को लागि प्रवेश स्वीकृत गरियो';
  }

  @override
  String get qrCodeNotFound =>
      'QR कोड फेला परेन वा पहिले नै प्रयोग गरिसकिएको छ।';

  @override
  String get qrCheckIn => 'QR चेक-इन';

  @override
  String get scanQrAtGate => 'प्रवेश द्वारमा QR स्क्यान गर्नुहोस्';

  @override
  String get manualQrCodeEntry => 'म्यानुअल QR कोड प्रविष्टि';

  @override
  String get enterQrCode => 'QR कोड प्रविष्ट गर्नुहोस्';

  @override
  String get validateEntry => 'प्रवेश मान्य गर्नुहोस्';

  @override
  String get noEventsAvailable => 'कुनै कार्यक्रमहरू उपलब्ध छैनन्';

  @override
  String get all => 'सबै';

  @override
  String get deleteUser => 'प्रयोगकर्ता मेटाउनुहोस्';

  @override
  String areYouSureDeleteUser(String name) {
    return 'के तपाईं $name लाई मेटाउन निश्चित हुनुहुन्छ?';
  }

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get editUser => 'प्रयोगकर्ता सम्पादन गर्नुहोस्';

  @override
  String get organisation => 'संस्था';

  @override
  String get manageEvent => 'कार्यक्रम व्यवस्थापन गर्नुहोस्';

  @override
  String get changeStatus => 'स्थिति परिवर्तन गर्नुहोस्';

  @override
  String get deleteEvent => 'मेटाउनुहोस्';

  @override
  String get areYouSureDeleteEvent =>
      'के तपाईं यो कार्यक्रम मेटाउन निश्चित हुनुहुन्छ? यो कार्य फिर्ता लिन सकिँदैन।';

  @override
  String get eventRequestCard => 'कार्यक्रम अनुरोध कार्ड';

  @override
  String get saveChanges => 'सेभ गर्नुहोस्';

  @override
  String get scanAttendeeQr => 'सहभागीको QR स्क्यान गर्नुहोस्';

  @override
  String get cameraOpensHere => 'क्यामेरा यहाँ खुल्छ';

  @override
  String get mobileScannerPlugin => '(mobile_scanner प्लगइन)';

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get organiserRegistered => 'आयोजक दर्ता भयो!';

  @override
  String get organiserLoginCredentialsAssigned =>
      'आयोजकलाई लगइन प्रमाणहरू तोकिएको छ। उनीहरूले पूर्वनिर्धारित पासवर्ड (Org@1234) प्रयोग गर्न सक्छन् र पहिलो लगइनमा परिवर्तन गर्न सक्छन्।';

  @override
  String get done => 'सम्पन्न भयो';

  @override
  String get registerNewOrganiser => 'नयाँ आयोजक दर्ता गर्नुहोस्';

  @override
  String get defaultPasswordAssignedDesc =>
      'एउटा पूर्वनिर्धारित पासवर्ड (Org@1234) तोकिनेछ र आयोजकलाई इमेल गरिनेछ। उनीहरूले यसलाई पहिलो लगइनमा परिवर्तन गर्नुपर्छ।';

  @override
  String get required => 'आवश्यक';

  @override
  String get invalidEmail => 'अमान्य इमेल';

  @override
  String get organisationNameOptional => 'संस्थाको नाम (वैकल्पिक)';

  @override
  String get registerOrganiser => 'आयोजक दर्ता गर्नुहोस्';

  @override
  String get myEvents => 'मेरा कार्यक्रमहरू';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get organiser => 'आयोजक';

  @override
  String nprParam(String param) {
    return 'NPR $param';
  }

  @override
  String get promoCodes => 'प्रोमो कोडहरू';

  @override
  String get createAction => '+ सिर्जना गर्नुहोस्';

  @override
  String get noEventsYet => 'अहिलेसम्म कुनै कार्यक्रमहरू छैनन्।';

  @override
  String get tapCreateToAddFirstEvent =>
      'तपाईंको पहिलो कार्यक्रम थप्न \"+ सिर्जना गर्नुहोस्\" मा ट्याप गर्नुहोस्।';

  @override
  String get create => 'सिर्जना गर्नुहोस्';

  @override
  String get eventAnalyticsReport => 'कार्यक्रम विश्लेषण रिपोर्ट';

  @override
  String nameParam(String param) {
    return 'नाम: $param';
  }

  @override
  String dateParam(String param) {
    return 'मिति: $param';
  }

  @override
  String get kpis => 'मुख्य प्रदर्शन सूचकहरू (KPIs)';

  @override
  String get generatedBySystem => 'Eventopia प्रणाली द्वारा उत्पन्न';

  @override
  String get createEventsToSeeAnalytics =>
      'विश्लेषण हेर्न कार्यक्रमहरू सिर्जना गर्नुहोस्।';

  @override
  String get downloadPdfReport => 'PDF रिपोर्ट डाउनलोड गर्नुहोस्';

  @override
  String ofParamTotal(String param) {
    return '$param कुल मध्ये';
  }

  @override
  String get ticketVerified => 'टिकट प्रमाणित भयो';

  @override
  String get scanFailed => 'स्क्यान विफल भयो';

  @override
  String get ok => 'ठिक छ';

  @override
  String get scanTicket => 'टिकट स्क्यान';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get eventAddedSuccessfully => 'कार्यक्रम सफलतापूर्वक थपिएको छ!';

  @override
  String get createNewEvent => 'नयाँ कार्यक्रम सिर्जना गर्नुहोस्';

  @override
  String get eventPoster => 'कार्यक्रम पोस्टर';

  @override
  String get change => 'परिवर्तन गर्नुहोस्';

  @override
  String get remove => 'हटाउनुहोस्';

  @override
  String get tapToAddEventPoster => 'कार्यक्रम पोस्टर थप्न ट्याप गर्नुहोस्';

  @override
  String get recommendedPosterSize => 'सिफारिस गरिएको: १२०० × ८०० px';

  @override
  String get eventTitle => 'कार्यक्रमको शीर्षक';

  @override
  String get description => 'विवरण';

  @override
  String get location => 'स्थान';

  @override
  String get date => 'मिति';

  @override
  String get start => 'सुरु';

  @override
  String get end => 'अन्त्य';

  @override
  String get ticketCategories => 'टिकट श्रेणीहरू';

  @override
  String get priceNpr => 'मूल्य (NPR)';

  @override
  String get capacity => 'क्षमता';

  @override
  String get promoCodeOptional => 'प्रोमो कोड (वैकल्पिक)';

  @override
  String get codeExample => 'कोड (जस्तै SAVE20)';

  @override
  String get discountPercentage => 'छुट %';

  @override
  String get createEvent => 'कार्यक्रम सिर्जना';

  @override
  String minParam(String param) {
    return 'न्यूनतम $param';
  }

  @override
  String get editEvent => 'कार्यक्रम सम्पादन गर्नुहोस्';

  @override
  String get time => 'समय';

  @override
  String get seats => 'सिटहरू';

  @override
  String get ticketTypes => 'टिकट प्रकारहरू';

  @override
  String paramOff(String param) {
    return '$param% छुट';
  }

  @override
  String get explore => 'अन्वेषण गर्नुहोस्';

  @override
  String get tickets => 'टिकटहरू';

  @override
  String get discoverConnectCelebrate =>
      'अन्वेषण गर्नुहोस्। जोडिनुहोस्। उत्सव मनाउनुहोस्।';

  @override
  String get myBookings => 'मेरा बुकिङहरू';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String nprAmount(String amount) {
    return 'NPR $amount';
  }

  @override
  String get upcomingEvents => 'आगामी कार्यक्रमहरू';

  @override
  String get noUpcomingEvents => 'कुनै आगामी कार्यक्रमहरू छैनन्।';

  @override
  String get bookings => 'बुकिङहरू';

  @override
  String get exploreEvents => 'कार्यक्रमहरू अन्वेषण गर्नुहोस्';

  @override
  String get searchEvents => 'कार्यक्रमहरू खोज्नुहोस्…';

  @override
  String get noEventsMatchSearch =>
      'तपाईंको खोजीसँग कुनै कार्यक्रमहरू मेल खाँदैनन्।';

  @override
  String get eventUpper => 'कार्यक्रम';

  @override
  String get completedUpper => 'सम्पन्न';

  @override
  String get upcomingUpper => 'आगामी';

  @override
  String get about => 'बारेमा';

  @override
  String get availablePromoCodes => 'उपलब्ध प्रोमो कोडहरू';

  @override
  String useCodeForDiscount(String code, String discount) {
    return '$discount% छुटको लागि कोड $code प्रयोग गर्नुहोस्!';
  }

  @override
  String remainingCount(String count) {
    return '$count बाँकी';
  }

  @override
  String get eventEnded => 'कार्यक्रम समाप्त भयो';

  @override
  String get bookNow => 'अहिले बुक गर्नुहोस्';

  @override
  String get notAvailable => 'उपलब्ध छैन';

  @override
  String get myTickets => 'मेरा टिकटहरू';

  @override
  String get upcoming => 'आगामी';

  @override
  String get past => 'विगत';

  @override
  String get cancelled => 'रद्द गरियो';

  @override
  String get noTicketsYet => 'अहिलेसम्म कुनै टिकटहरू छैनन्।';

  @override
  String get notifications => 'सूचनाहरू';

  @override
  String get noNotificationsYet => 'अहिलेसम्म कुनै सूचनाहरू छैनन्';

  @override
  String get payment => 'भुक्तानी';

  @override
  String get otpSentMessage =>
      'तपाईंको दर्ता गरिएको मोबाइल/इमेलमा OTP पठाइएको छ। (पूर्वनिर्धारित: १२३४)';

  @override
  String get invalidOtpMessage => 'अमान्य OTP। कृपया पुन: प्रयास गर्नुहोस्।';

  @override
  String get orderSummary => 'अर्डर सारांश';

  @override
  String get enterPin => 'पिन प्रविष्ट गर्नुहोस्';

  @override
  String get event => 'कार्यक्रम';

  @override
  String get ticket => 'टिकट';

  @override
  String categoryQuantity(String category, String quantity) {
    return '$category × $quantity';
  }

  @override
  String get subtotal => 'उप-कुल';

  @override
  String promoCode(String code) {
    return 'प्रोमो: $code';
  }

  @override
  String negativeNprAmount(String amount) {
    return '- NPR $amount';
  }

  @override
  String get totalToPay => 'तिर्नुपर्ने कुल रकम';

  @override
  String get selectPaymentMethod => 'भुक्तानी विधि चयन गर्नुहोस्';

  @override
  String get card => 'कार्ड';

  @override
  String get esewa => 'ईसेवा';

  @override
  String get pay => 'तिर्नुहोस्';

  @override
  String get enterOtpToConfirm => 'भुक्तानी पुष्टि गर्न OTP प्रविष्ट गर्नुहोस्';

  @override
  String get otpLabel => 'OTP : १२३४';

  @override
  String verifyAndPay(String amount) {
    return 'प्रमाणित गर्नुहोस् र तिर्नुहोस् – NPR $amount';
  }

  @override
  String get maxSeatsAllowed => 'प्रति बुकिङ अधिकतम १० सिटहरू अनुमति छ।';

  @override
  String get chooseTicketCategoryFirst => 'पहिले टिकट श्रेणी छनौट गर्नुहोस्';

  @override
  String categoryPrice(String category, String price) {
    return '$category (NPR $price)';
  }

  @override
  String get selected => 'चयन गरियो';

  @override
  String get booked => 'बुक गरियो';

  @override
  String get pleaseSelectCategory =>
      'सिटहरू छनौट गर्न कृपया टिकट श्रेणी चयन गर्नुहोस्';

  @override
  String get stageUpper => 'मञ्च';

  @override
  String get controlRoomUpper => 'नियन्त्रण कक्ष';

  @override
  String seatsSelected(String count) {
    return '$count सिट(हरू) चयन गरियो';
  }

  @override
  String get continueAction => 'अगाडि बढ्नुहोस्';

  @override
  String get eventopiaUpper => 'EVENTOPIA';

  @override
  String get eTicketUpper => 'ई-टिकट';

  @override
  String get confirmedUpper => 'पुष्टि भयो';

  @override
  String get detail => 'विवरण';

  @override
  String get info => 'जानकारी';

  @override
  String get ticketType => 'टिकट प्रकार';

  @override
  String get quantity => 'मात्रा';

  @override
  String get section => 'खण्ड';

  @override
  String get discount => 'छुट';

  @override
  String get totalPaid => 'कुल भुक्तान';

  @override
  String get bookedOn => 'बुक गरिएको मिति';

  @override
  String get reference => 'सन्दर्भ';

  @override
  String get scanQrAtEntry => 'प्रवेश द्वारमा यो QR स्क्यान गर्नुहोस्';

  @override
  String generatedBy(String date) {
    return '$date मा Eventopia द्वारा उत्पन्न';
  }

  @override
  String get ticketConfirmed => 'टिकट पुष्टि भयो!';

  @override
  String get showQrAtEntry => 'प्रवेश द्वारमा यो QR कोड देखाउनुहोस्';

  @override
  String promoApplied(String discount) {
    return 'कोड लागू भयो! $discount% छुट';
  }

  @override
  String get invalidPromoCode => 'अमान्य वा म्याद सकिएको कोड';

  @override
  String get bookingFailed => 'बुकिङ विफल भयो। कृपया पुन: प्रयास गर्नुहोस्।';

  @override
  String get selectTicketType => 'टिकट प्रकार चयन गर्नुहोस्';

  @override
  String countLeft(String count) {
    return '$count बाँकी';
  }

  @override
  String get apply => 'लागू गर्नुहोस्';

  @override
  String discountWithPercent(String discount) {
    return 'छुट ($discount%)';
  }

  @override
  String get total => 'कुल';

  @override
  String get selectATicketType => 'एउटा टिकट प्रकार चयन गर्नुहोस्';

  @override
  String get proceedToPay => 'भुक्तानी गर्न अगाडि बढ्नुहोस्';

  @override
  String get eventSoldOut => 'यो कार्यक्रम बिक्री भइसकेको छ।';

  @override
  String get onWaitlist => 'तपाईं प्रतीक्षा सूचीमा हुनुहुन्छ!';

  @override
  String get joinWaitlistDesc =>
      'प्रतीक्षा सूचीमा सामेल हुनुहोस् — टिकटहरू उपलब्ध भएपछि हामी तपाईंलाई सूचित गर्नेछौं।';

  @override
  String get joinWaitlist => 'प्रतीक्षा सूचीमा सामेल हुनुहोस्';

  @override
  String quantityMultiplier(String quantity) {
    return '× $quantity';
  }

  @override
  String get downloadTicket => 'टिकट डाउनलोड गर्नुहोस्';

  @override
  String get bookingCancelledRefunded =>
      'यो बुकिङ रद्द गरिएको छ। फिर्ता रकम प्रदान गरिएको छ।';

  @override
  String get bookingCancelledRefundedSuccess =>
      'बुकिङ रद्द गरियो। फिर्ता रकम प्रदान गरिएको छ।';

  @override
  String get cannotCancelWindowPassed =>
      'रद्द गर्न सकिँदैन — ७-दिनको समय सीमा समाप्त भयो।';

  @override
  String get cancelBooking => 'बुकिङ रद्द गर्नुहोस्';

  @override
  String ofTotalSeats(String total) {
    return 'कुल $total सिटमध्ये';
  }

  @override
  String categorySalesProgress(String category, String sold) {
    return '$category: $sold टिकट बिक्री भयो';
  }

  @override
  String get newBooking => 'नयाँ बुकिङ';

  @override
  String newBookingMessage(String attendee, int quantity, String eventTitle) {
    return '$attendee • $quantity टिकट • $eventTitle';
  }

  @override
  String get ticketsAvailable => 'टिकट उपलब्ध छन्';

  @override
  String waitlistPosition(String position) {
    return 'स्थान $position';
  }

  @override
  String get eventStatusUpdated => 'कार्यक्रमको स्थिति अद्यावधिक गरियो';

  @override
  String eventApprovedByAdmin(String eventTitle) {
    return 'तपाईंको कार्यक्रम \"$eventTitle\" प्रशासकद्वारा स्वीकृत गरिएको छ।';
  }

  @override
  String eventStatusChanged(String eventTitle, String status) {
    return 'तपाईंको कार्यक्रम \"$eventTitle\" को स्थिति अब $status छ।';
  }
}
