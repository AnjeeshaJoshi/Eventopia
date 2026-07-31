// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get whatsPoppin => 'What\'s Poppin\' at HELP?';

  @override
  String get soldOut => 'बिक चुका है';

  @override
  String get full => 'पूर्ण';

  @override
  String seatsLeft(String seats) {
    return '$seats left';
  }

  @override
  String fromNpr(String price) {
    return 'From NPR $price';
  }

  @override
  String get admin => 'प्रशासक';

  @override
  String get organizer => 'आयोजक';

  @override
  String get attendee => 'प्रतिभागी';

  @override
  String get weak => 'कमज़ोर';

  @override
  String get fair => 'ठीक';

  @override
  String get good => 'अच्छा';

  @override
  String get strong => 'मज़बूत';

  @override
  String passwordStrength(String label) {
    return 'पासवर्ड की मजबूती: $label';
  }

  @override
  String get changeDefaultPasswordPrompt =>
      'जारी रखने के लिए कृपया अपना डिफ़ॉल्ट पासवर्ड बदलें।';

  @override
  String get appTitle => 'Eventopia';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है!';

  @override
  String get back => 'वापस';

  @override
  String get toggleVisibility => 'Show/Hide Password';

  @override
  String get loginToContinue => 'जारी रखने के लिए लॉग इन करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get emailIsRequired => 'ईमेल आवश्यक है';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordIsRequired => 'पासवर्ड ज़रूरी है';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get logIn => 'लॉग इन';

  @override
  String get dontHaveAccount => 'क्या आपका अकाउंट नहीं है? ';

  @override
  String get createAccountTitle => 'अकाउंट बनाएं';

  @override
  String get joinEventopia => 'इवेंटोपिया से जुड़ें';

  @override
  String get registeringAs => 'रजिस्टर करें:';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get fullNameIsRequired => 'पूरा नाम आवश्यक है';

  @override
  String get nameIsTooShort => 'नाम बहुत छोटा है';

  @override
  String get enterValidEmail => 'मान्य ईमेल पता दर्ज करें';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get phoneIsRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get enterValidPhone => 'मान्य फ़ोन नंबर दर्ज करें';

  @override
  String get minimumSixChars => 'कम से कम छह अक्षर';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get pleaseConfirmPassword => 'कृपया पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get alreadyHaveAccount => 'पहले से अकाउंट है?';

  @override
  String get signIn => 'साइन इन';

  @override
  String get home => 'होम';

  @override
  String get users => 'उपयोगकर्ता';

  @override
  String get events => 'कार्यक्रम';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get eventRequests => 'कार्यक्रम अनुरोध';

  @override
  String get noPendingRequests => 'कोई लंबित अनुरोध नहीं है';

  @override
  String byOrganizer(String organizer) {
    return 'By $organizer';
  }

  @override
  String get eventRejected => 'इवेंट अस्वीकार कर दिया गया';

  @override
  String get reject => 'अस्वीकार';

  @override
  String get eventApproved => 'इवेंट मंज़ूर हो गया';

  @override
  String get approve => 'मंज़ूरी';

  @override
  String get noUserLoggedIn => 'कोई भी यूज़र लॉग इन नहीं है';

  @override
  String get administrator => 'प्रशासक';

  @override
  String get organisers => 'आयोजक';

  @override
  String get attendees => 'प्रतिभागी';

  @override
  String get revenue => 'राजस्व';

  @override
  String nprRevenue(String revenue) {
    return 'NPR $revenue';
  }

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get addOrganiser => 'आयोजक\nजोड़ें';

  @override
  String get eventRequestsQuickAction => 'Event\nRequests';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get allEvents => 'सभी कार्यक्रम';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get auditoriumOccupancy => 'ऑडिटोरियम में लोगों की संख्या';

  @override
  String seatsBooked(String booked, String total) {
    return '$booked / $total seats booked';
  }

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get name => 'नाम';

  @override
  String get phone => 'फ़ोन';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get pleaseFillAllFields => 'कृपया सभी क्षेत्रों को भरें';

  @override
  String get profileUpdatedSuccessfully =>
      'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई है।';

  @override
  String get save => 'सहेजें';

  @override
  String get email => 'ईमेल';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get passwordChangedSuccessfully => 'पासवर्ड सफलतापूर्वक बदल दिया गया';

  @override
  String get update => 'अपडेट करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get eventopiaAnalytics => 'इवेंटोपिया एनालिटिक्स';

  @override
  String get report => 'प्रतिवेदन';

  @override
  String get eventDetails => 'इवेंट की जानकारी';

  @override
  String nameDetail(String name) {
    return 'Name: $name';
  }

  @override
  String dateDetail(String date) {
    return 'Date: $date';
  }

  @override
  String organizerDetail(String organizer) {
    return 'Organizer: $organizer';
  }

  @override
  String locationDetail(String location) {
    return 'Location: $location';
  }

  @override
  String get kpi => 'Key Performance Indicators';

  @override
  String get metric => 'Metric';

  @override
  String get value => 'Value';

  @override
  String get totalTicketsSold => 'Total Tickets Sold';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get occupancyRate => 'Occupancy Rate';

  @override
  String occupancyProgress(String title, String percent) {
    return '$title occupancy $percent%';
  }

  @override
  String get availableSeats => 'उपलब्ध सीट';

  @override
  String get salesByTicketCategory => 'टिकट कैटेगरी के अनुसार बिक्री';

  @override
  String get category => 'कैटेगरी';

  @override
  String get ticketsSold => 'टिकट बिके';

  @override
  String generatedOnBySystem(String date) {
    return '$date को Eventopia सिस्टम द्वारा जनरेट किया गया';
  }

  @override
  String failedToGeneratePdf(String error) {
    return 'PDF बनाने में समस्या हुई: $error';
  }

  @override
  String get reportsAndAnalytics => 'रिपोर्ट और एनालिटिक्स';

  @override
  String get noEventsToShowAnalytics =>
      'एनालिटिक्स दिखाने के लिए कोई इवेंट उपलब्ध नहीं है।';

  @override
  String get selectEvent => 'इवेंट चुनें';

  @override
  String ofTotal(String total) {
    return 'of $total total';
  }

  @override
  String get occupancy => 'अधिभोग';

  @override
  String get available => 'उपलब्ध';

  @override
  String get sevenDayRevenue => '7-दिन का रेवेन्यू';

  @override
  String get salesByCategory => 'कैटेगरी के अनुसार बिक्री';

  @override
  String get passwordChangedPleaseLogin =>
      'पासवर्ड सफलतापूर्वक बदल दिया गया है। कृपया लॉग इन करें।';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get enterNewPasswordDesc =>
      'अपने अकाउंट को सुरक्षित करने के लिए नीचे एक नया पासवर्ड डालें।';

  @override
  String entryApprovedFor(String title) {
    return 'Entry approved for \"$title\"';
  }

  @override
  String get qrCodeNotFound =>
      'QR कोड नहीं मिला या पहले ही इस्तेमाल हो चुका है।';

  @override
  String get qrCheckIn => 'QR चेक-इन';

  @override
  String get scanQrAtGate => 'एंट्री गेट पर QR स्कैन करें';

  @override
  String get manualQrCodeEntry => 'मैन्युअल QR कोड एंट्री';

  @override
  String get enterQrCode => 'QR कोड डालें';

  @override
  String get validateEntry => 'एंट्री को मान्य करें';

  @override
  String get noEventsAvailable => 'कोई इवेंट उपलब्ध नहीं है';

  @override
  String get all => 'सभी';

  @override
  String get deleteUser => 'उपयोगकर्ता को हटाएँ';

  @override
  String areYouSureDeleteUser(String name) {
    return 'क्या आप आश्वस्त है कि आपको $name डिलीट करना है?';
  }

  @override
  String get delete => 'हटाएँ';

  @override
  String get editUser => 'उपयोगकर्ता संपादित करें';

  @override
  String get organisation => 'Organisation';

  @override
  String get manageEvent => 'कार्यक्रम प्रबंधित करें';

  @override
  String get changeStatus => 'स्थिति बदलें';

  @override
  String get deleteEvent => 'कार्यक्रम हटाएँ';

  @override
  String get areYouSureDeleteEvent =>
      'क्या आप इस कार्यक्रम को हटाना चाहते हैं? यह कार्रवाई वापस नहीं की जा सकती।';

  @override
  String get eventRequestCard => 'Event request card';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get scanAttendeeQr => 'QR स्कैन करें';

  @override
  String get cameraOpensHere => 'कैमरा यहाँ खुलता है';

  @override
  String get mobileScannerPlugin => '(mobile_scanner plugin)';

  @override
  String get close => 'बंद करें';

  @override
  String get organiserRegistered => 'आयोजक पंजीकृत!';

  @override
  String get organiserLoginCredentialsAssigned =>
      'ऑर्गनाइज़र को लॉगिन क्रेडेंशियल दे दिए गए हैं। वे डिफ़ॉल्ट पासवर्ड (Org@1234) का इस्तेमाल कर सकते हैं और पहली बार लॉगिन करने पर इसे बदल सकते हैं।';

  @override
  String get done => 'पूरा करें';

  @override
  String get registerNewOrganiser => 'नया ऑर्गनाइज़र रजिस्टर करें';

  @override
  String get defaultPasswordAssignedDesc =>
      'एक डिफ़ॉल्ट पासवर्ड (Org@1234) तय किया जाएगा और ऑर्गनाइज़र को ईमेल किया जाएगा। उन्हें पहली बार लॉग इन करने पर इसे बदलना होगा।';

  @override
  String get required => 'ज़रूरी';

  @override
  String get invalidEmail => 'अमान्य ईमेल';

  @override
  String get organisationNameOptional => 'संगठन का नाम (वैकल्पिक)';

  @override
  String get registerOrganiser => 'रजिस्टर करें';

  @override
  String get myEvents => 'मेरे कार्यक्रम';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get organiser => 'ऑर्गनाइज़र';

  @override
  String nprParam(String param) {
    return 'NPR $param';
  }

  @override
  String get promoCodes => 'प्रोमो कोड';

  @override
  String get createAction => '+ इवेंट बनाएँ';

  @override
  String get noEventsYet => 'अभी कोई कार्यक्रम नहीं है।';

  @override
  String get tapCreateToAddFirstEvent =>
      'अपना पहला इवेंट जोड़ने के लिए \'+ इवेंट बनाएँ\' पर टैप करें।';

  @override
  String get create => 'बनाएँ';

  @override
  String get eventAnalyticsReport => 'इवेंट एनालिटिक्स रिपोर्ट';

  @override
  String nameParam(String param) {
    return 'Name: $param';
  }

  @override
  String dateParam(String param) {
    return 'Date: $param';
  }

  @override
  String get kpis => 'Key Performance Indicators (KPIs)';

  @override
  String get generatedBySystem => 'Generated by Eventopia System';

  @override
  String get createEventsToSeeAnalytics =>
      'एनालिटिक्स देखने के लिए इवेंट बनाएं।';

  @override
  String get downloadPdfReport => 'PDF रिपोर्ट डाउनलोड करें';

  @override
  String ofParamTotal(String param) {
    return 'of $param total';
  }

  @override
  String get ticketVerified => 'टिकट वेरिफ़ाई हो गया';

  @override
  String get scanFailed => 'स्कैन विफल रहा';

  @override
  String get ok => 'ठीक है';

  @override
  String get scanTicket => 'टिकट स्कैन करें';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get eventAddedSuccessfully => 'इवेंट सफलतापूर्वक जोड़ दिया गया!';

  @override
  String get createNewEvent => 'नया इवेंट बनाएँ';

  @override
  String get eventPoster => 'इवेंट पोस्टर';

  @override
  String get change => 'परिवर्तन';

  @override
  String get remove => 'निकालना';

  @override
  String get tapToAddEventPoster => 'इवेंट पोस्टर जोड़ने के लिए टैप करें';

  @override
  String get recommendedPosterSize => 'अनुशंसित: 1200 × 800 px';

  @override
  String get eventTitle => 'कार्यक्रम शीर्षक';

  @override
  String get description => 'विवरण';

  @override
  String get location => 'स्थान';

  @override
  String get date => 'तारीख';

  @override
  String get start => 'शुरू';

  @override
  String get end => 'खत्म';

  @override
  String get ticketCategories => 'टिकट श्रेणियाँ';

  @override
  String get priceNpr => 'कीमत (NPR)';

  @override
  String get capacity => 'क्षमता';

  @override
  String get promoCodeOptional => 'प्रोमो कोड (वैकल्पिक)';

  @override
  String get codeExample => 'Code (e.g. SAVE20)';

  @override
  String get discountPercentage => 'Discount %';

  @override
  String get createEvent => 'इवेंट बनाएँ';

  @override
  String minParam(String param) {
    return 'Min $param';
  }

  @override
  String get editEvent => 'इवेंट संपादित करें';

  @override
  String get time => 'समय';

  @override
  String get seats => 'सीटें';

  @override
  String get ticketTypes => 'टिकट प्रकार';

  @override
  String paramOff(String param) {
    return '$param% off';
  }

  @override
  String get explore => 'खोजें';

  @override
  String get tickets => 'टिकट';

  @override
  String get discoverConnectCelebrate => 'जानें। जुड़ें। जश्न मनाएं।';

  @override
  String get myBookings => 'मेरी बुकिंग';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String nprAmount(String amount) {
    return 'NPR $amount';
  }

  @override
  String get upcomingEvents => 'आगामी कार्यक्रम';

  @override
  String get noUpcomingEvents => 'कोई आगामी कार्यक्रम नहीं है।';

  @override
  String get bookings => 'बुकिंग';

  @override
  String get exploreEvents => 'इवेंट्स खोजें';

  @override
  String get searchEvents => 'कार्यक्रम खोजें…';

  @override
  String get noEventsMatchSearch =>
      'आपकी खोज से मेल खाने वाला कोई इवेंट नहीं है।';

  @override
  String get eventUpper => 'इवेंट';

  @override
  String get completedUpper => 'पूरा';

  @override
  String get upcomingUpper => 'आगामी';

  @override
  String get about => 'इवेंट के बारे में';

  @override
  String get availablePromoCodes => 'उपलब्ध प्रोमो कोड';

  @override
  String useCodeForDiscount(String code, String discount) {
    return '$discount% की छूट के लिए $code कोड का इस्तेमाल करें।';
  }

  @override
  String remainingCount(String count) {
    return '$count remaining';
  }

  @override
  String get eventEnded => 'इवेंट समाप्त';

  @override
  String get bookNow => 'अभी बुक करें';

  @override
  String get notAvailable => 'उपलब्ध नहीं';

  @override
  String get myTickets => 'मेरे टिकट';

  @override
  String get upcoming => 'आगामी';

  @override
  String get past => 'पिछले';

  @override
  String get cancelled => 'रद्द';

  @override
  String get noTicketsYet => 'अभी तक कोई टिकट नहीं।';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get noNotificationsYet => 'अभी कोई सूचना नहीं है';

  @override
  String get payment => 'भुगतान';

  @override
  String get otpSentMessage =>
      'OTP has been sent to your registered mobile/email. (Default: 1234)';

  @override
  String get invalidOtpMessage => 'Invalid OTP. Please try again.';

  @override
  String get orderSummary => 'ऑर्डर सारांश';

  @override
  String get enterPin => 'पिन दर्ज करें';

  @override
  String get event => 'कार्यक्रम';

  @override
  String get ticket => 'टिकट';

  @override
  String categoryQuantity(String category, String quantity) {
    return '$category × $quantity';
  }

  @override
  String get subtotal => 'उप-योग';

  @override
  String promoCode(String code) {
    return 'Promo: $code';
  }

  @override
  String negativeNprAmount(String amount) {
    return '- NPR $amount';
  }

  @override
  String get totalToPay => 'कुल भुगतान';

  @override
  String get selectPaymentMethod => 'भुगतान का तरीका चुनें';

  @override
  String get card => 'कार्ड';

  @override
  String get esewa => 'ई-सेवा';

  @override
  String get pay => 'भुगतान करें';

  @override
  String get enterOtpToConfirm => 'Enter OTP to Confirm Payment';

  @override
  String get otpLabel => 'OTP : 1234';

  @override
  String verifyAndPay(String amount) {
    return 'सत्यापित और भुगतान करें – NPR $amount';
  }

  @override
  String get maxSeatsAllowed =>
      'हर बुकिंग पर ज़्यादा से ज़्यादा 10 सीटें बुक की जा सकती हैं।';

  @override
  String get chooseTicketCategoryFirst => 'सबसे पहले टिकट कैटेगरी चुनें';

  @override
  String categoryPrice(String category, String price) {
    return '$category (NPR $price)';
  }

  @override
  String get selected => 'चयनित';

  @override
  String get booked => 'बुक हो चुका';

  @override
  String get pleaseSelectCategory =>
      'सीटें चुनने के लिए कृपया टिकट की श्रेणी चुनें';

  @override
  String get stageUpper => 'STAGE';

  @override
  String get controlRoomUpper => 'CONTROL ROOM';

  @override
  String seatsSelected(String count) {
    return '$count सीट चुनी गईं';
  }

  @override
  String get continueAction => 'जारी';

  @override
  String get eventopiaUpper => 'EVENTOPIA';

  @override
  String get eTicketUpper => 'E-TICKET';

  @override
  String get confirmedUpper => 'CONFIRMED';

  @override
  String get detail => 'Detail';

  @override
  String get info => 'Info';

  @override
  String get ticketType => 'टिकटको प्रकार';

  @override
  String get quantity => 'मात्रा';

  @override
  String get section => 'खण्ड';

  @override
  String get discount => 'छुट';

  @override
  String get totalPaid => 'कुल भुक्तानी';

  @override
  String get bookedOn => 'बुक गरिएको';

  @override
  String get reference => 'सन्दर्भ';

  @override
  String get scanQrAtEntry => 'एंट्री पर यह QR स्कैन करें।';

  @override
  String generatedBy(String date) {
    return 'Eventopia द्वारा $date को जनरेट किया गया';
  }

  @override
  String get ticketConfirmed => 'टिकट की पुष्टि हो गई!';

  @override
  String get showQrAtEntry => 'एंट्री पर यह QR कोड दिखाएं।';

  @override
  String promoApplied(String discount) {
    return 'कोड लागू हो गया $discount% डिस्काउंट';
  }

  @override
  String get invalidPromoCode => 'अमान्य या एक्सपायर हो चुका कोड';

  @override
  String get bookingFailed => 'बुकिंग फ़ेल हो गई। कृपया दोबारा कोशिश करें।';

  @override
  String get selectTicketType => 'टिकट का प्रकार चुनें';

  @override
  String countLeft(String count) {
    return '$count left';
  }

  @override
  String get apply => 'लागू';

  @override
  String discountWithPercent(String discount) {
    return 'Discount ($discount%)';
  }

  @override
  String get total => 'कुल';

  @override
  String get selectATicketType => 'टिकट का प्रकार चुने';

  @override
  String get proceedToPay => 'भुगतान करें';

  @override
  String get eventSoldOut => 'इस इवेंट के सभी टिकट बिक चुके हैं।';

  @override
  String get onWaitlist => 'आप प्रतीक्षा सूची में हैं!';

  @override
  String get joinWaitlistDesc =>
      'वेटलिस्ट में शामिल हों — टिकट उपलब्ध होने पर हम आपको सूचित करेंगे।';

  @override
  String get joinWaitlist => 'प्रतीक्षा सूची में जुड़ें';

  @override
  String quantityMultiplier(String quantity) {
    return '× $quantity';
  }

  @override
  String get downloadTicket => 'टिकट डाउनलोड करें';

  @override
  String get bookingCancelledRefunded =>
      'यह बुकिंग रद्द कर दी गई है। रिफंड कर दिया गया है।';

  @override
  String get bookingCancelledRefundedSuccess =>
      'बुकिंग रद्द कर दी गई है। रिफंड कर दिया गया है।';

  @override
  String get cannotCancelWindowPassed =>
      'बुकिंग रद्द कर दी गई है। रिफंड कर दिया गया है।';

  @override
  String get cancelBooking => 'बुकिंग रद्द';

  @override
  String ofTotalSeats(String total) {
    return 'कुल $total सीटों में से';
  }

  @override
  String categorySalesProgress(String category, String sold) {
    return '$category: $sold tickets sold';
  }

  @override
  String get newBooking => 'नई बुकिंग';

  @override
  String newBookingMessage(String attendee, int quantity, String eventTitle) {
    return '$attendee • $quantity टिकट • $eventTitle';
  }

  @override
  String get ticketsAvailable => 'टिकट उपलब्ध हैं';

  @override
  String waitlistPosition(String position) {
    return 'स्थान $position';
  }

  @override
  String get eventStatusUpdated => 'इवेंट की स्थिति अपडेट की गई';

  @override
  String eventApprovedByAdmin(String eventTitle) {
    return 'आपका इवेंट \"$eventTitle\" एडमिन द्वारा मंज़ूर कर दिया गया है।';
  }

  @override
  String eventStatusChanged(String eventTitle, String status) {
    return 'आपके इवेंट \"$eventTitle\" की स्थिति अब $status है।';
  }
}
