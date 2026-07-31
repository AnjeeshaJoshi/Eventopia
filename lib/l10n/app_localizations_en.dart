// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get whatsPoppin => 'What\'s Poppin\' at HELP?';

  @override
  String get soldOut => 'SOLD OUT';

  @override
  String get full => 'Full';

  @override
  String seatsLeft(String seats) {
    return '$seats left';
  }

  @override
  String fromNpr(String price) {
    return 'From NPR $price';
  }

  @override
  String get admin => 'Admin';

  @override
  String get organizer => 'Organizer';

  @override
  String get attendee => 'Attendee';

  @override
  String get weak => 'Weak';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get strong => 'Strong';

  @override
  String passwordStrength(String label) {
    return 'Password strength: $label';
  }

  @override
  String get changeDefaultPasswordPrompt =>
      'Please change your default password to continue.';

  @override
  String get appTitle => 'Eventopia';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get back => 'Back';

  @override
  String get toggleVisibility => 'Show/Hide Password';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get password => 'Password';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get logIn => 'Log In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get joinEventopia => 'Join Eventopia';

  @override
  String get registeringAs => 'Registering as: ';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameIsRequired => 'Full name is required';

  @override
  String get nameIsTooShort => 'Name is too short';

  @override
  String get enterValidEmail => 'Enter a valid email address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneIsRequired => 'Phone number is required';

  @override
  String get enterValidPhone => 'Enter a valid phone number';

  @override
  String get minimumSixChars => 'Minimum 6 characters';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account?  ';

  @override
  String get signIn => 'Sign In';

  @override
  String get home => 'Home';

  @override
  String get users => 'Users';

  @override
  String get events => 'Events';

  @override
  String get profile => 'Profile';

  @override
  String get eventRequests => 'Event Requests';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String byOrganizer(String organizer) {
    return 'By $organizer';
  }

  @override
  String get eventRejected => 'Event rejected';

  @override
  String get reject => 'Reject';

  @override
  String get eventApproved => 'Event approved';

  @override
  String get approve => 'Approve';

  @override
  String get noUserLoggedIn => 'No user logged in';

  @override
  String get administrator => 'Administrator';

  @override
  String get organisers => 'Organisers';

  @override
  String get attendees => 'Attendees';

  @override
  String get revenue => 'Revenue';

  @override
  String nprRevenue(String revenue) {
    return 'NPR $revenue';
  }

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addOrganiser => 'Add\nOrganiser';

  @override
  String get eventRequestsQuickAction => 'Event\nRequests';

  @override
  String get reports => 'Reports';

  @override
  String get allEvents => 'All Events';

  @override
  String get seeAll => 'See all';

  @override
  String get auditoriumOccupancy => 'Auditorium Occupancy';

  @override
  String seatsBooked(String booked, String total) {
    return '$booked / $total seats booked';
  }

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get cancel => 'Cancel';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get save => 'Save';

  @override
  String get email => 'Email';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get update => 'Update';

  @override
  String get signOut => 'Sign Out';

  @override
  String get eventopiaAnalytics => 'Eventopia Analytics';

  @override
  String get report => 'REPORT';

  @override
  String get eventDetails => 'Event Details';

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
  String get availableSeats => 'Available Seats';

  @override
  String get salesByTicketCategory => 'Sales by Ticket Category';

  @override
  String get category => 'Category';

  @override
  String get ticketsSold => 'Tickets Sold';

  @override
  String generatedOnBySystem(String date) {
    return 'Generated on $date by Eventopia System';
  }

  @override
  String failedToGeneratePdf(String error) {
    return 'Failed to generate PDF: $error';
  }

  @override
  String get reportsAndAnalytics => 'Reports & Analytics';

  @override
  String get noEventsToShowAnalytics =>
      'No events available to show analytics.';

  @override
  String get selectEvent => 'Select Event';

  @override
  String ofTotal(String total) {
    return 'of $total total';
  }

  @override
  String get occupancy => 'Occupancy';

  @override
  String get available => 'Available';

  @override
  String get sevenDayRevenue => '7-Day Revenue';

  @override
  String get salesByCategory => 'Sales by Category';

  @override
  String get passwordChangedPleaseLogin =>
      'Password changed successfully. Please login.';

  @override
  String get changePassword => 'Change Password';

  @override
  String get enterNewPasswordDesc =>
      'Enter a new password below to secure your account.';

  @override
  String entryApprovedFor(String title) {
    return 'Entry approved for \"$title\"';
  }

  @override
  String get qrCodeNotFound => 'QR code not found or already used.';

  @override
  String get qrCheckIn => 'QR Check-In';

  @override
  String get scanQrAtGate => 'Scan QR at entry gate';

  @override
  String get manualQrCodeEntry => 'Manual QR Code Entry';

  @override
  String get enterQrCode => 'Enter QR Code';

  @override
  String get validateEntry => 'Validate Entry';

  @override
  String get noEventsAvailable => 'No events available';

  @override
  String get all => 'All';

  @override
  String get deleteUser => 'Delete User';

  @override
  String areYouSureDeleteUser(String name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get editUser => 'Edit User';

  @override
  String get organisation => 'Organisation';

  @override
  String get manageEvent => 'Manage Event';

  @override
  String get changeStatus => 'Change Status';

  @override
  String get deleteEvent => 'Delete';

  @override
  String get areYouSureDeleteEvent =>
      'Are you sure you want to delete this event? This action cannot be undone.';

  @override
  String get eventRequestCard => 'Event request card';

  @override
  String get saveChanges => 'Save ';

  @override
  String get scanAttendeeQr => 'Scan Attendee QR';

  @override
  String get cameraOpensHere => 'Camera opens here';

  @override
  String get mobileScannerPlugin => '(mobile_scanner plugin)';

  @override
  String get close => 'Close';

  @override
  String get organiserRegistered => 'Organiser Registered!';

  @override
  String get organiserLoginCredentialsAssigned =>
      'Login credentials have been assigned to the organiser. They can use the default password (Org@1234) and change it on first login.';

  @override
  String get done => 'Done';

  @override
  String get registerNewOrganiser => 'Register New Organiser';

  @override
  String get defaultPasswordAssignedDesc =>
      'A default password (Org@1234) will be assigned and emailed to the organiser. They must change it on first login.';

  @override
  String get required => 'Required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get organisationNameOptional => 'Organisation Name (optional)';

  @override
  String get registerOrganiser => 'Register Organiser';

  @override
  String get myEvents => 'My Events';

  @override
  String get analytics => 'Analytics';

  @override
  String get organiser => 'Organiser';

  @override
  String nprParam(String param) {
    return 'NPR $param';
  }

  @override
  String get promoCodes => 'Promo Codes';

  @override
  String get createAction => '+ Create';

  @override
  String get noEventsYet => 'No events yet.';

  @override
  String get tapCreateToAddFirstEvent =>
      'Tap \"+ Create\" to add your first event.';

  @override
  String get create => 'Create';

  @override
  String get eventAnalyticsReport => 'EVENT ANALYTICS REPORT';

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
  String get createEventsToSeeAnalytics => 'Create events to see analytics.';

  @override
  String get downloadPdfReport => 'Download PDF Report';

  @override
  String ofParamTotal(String param) {
    return 'of $param total';
  }

  @override
  String get ticketVerified => 'Ticket Verified';

  @override
  String get scanFailed => 'Scan Failed';

  @override
  String get ok => 'OK';

  @override
  String get scanTicket => 'Scan Ticket';

  @override
  String get requiredField => 'Required';

  @override
  String get eventAddedSuccessfully => 'Event has been added successfully!';

  @override
  String get createNewEvent => 'Create New Event';

  @override
  String get eventPoster => 'Event Poster';

  @override
  String get change => 'Change';

  @override
  String get remove => 'Remove';

  @override
  String get tapToAddEventPoster => 'Tap to add event poster';

  @override
  String get recommendedPosterSize => 'Recommended: 1200 × 800 px';

  @override
  String get eventTitle => 'Event Title';

  @override
  String get description => 'Description';

  @override
  String get location => 'Location';

  @override
  String get date => 'Date';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get ticketCategories => 'Ticket Categories';

  @override
  String get priceNpr => 'Price (NPR)';

  @override
  String get capacity => 'Capacity';

  @override
  String get promoCodeOptional => 'Promo Code (Optional)';

  @override
  String get codeExample => 'Code (e.g. SAVE20)';

  @override
  String get discountPercentage => 'Discount %';

  @override
  String get createEvent => 'Create Event';

  @override
  String minParam(String param) {
    return 'Min $param';
  }

  @override
  String get editEvent => 'Edit Event';

  @override
  String get time => 'Time';

  @override
  String get seats => 'Seats';

  @override
  String get ticketTypes => 'Ticket Types';

  @override
  String paramOff(String param) {
    return '$param% off';
  }

  @override
  String get explore => 'Explore';

  @override
  String get tickets => 'Tickets';

  @override
  String get discoverConnectCelebrate => 'Discover. Connect. Celebrate.';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String nprAmount(String amount) {
    return 'NPR $amount';
  }

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get noUpcomingEvents => 'No upcoming events.';

  @override
  String get bookings => 'Bookings';

  @override
  String get exploreEvents => 'Explore Events';

  @override
  String get searchEvents => 'Search events…';

  @override
  String get noEventsMatchSearch => 'No events match your search.';

  @override
  String get eventUpper => 'EVENT';

  @override
  String get completedUpper => 'COMPLETED';

  @override
  String get upcomingUpper => 'UPCOMING';

  @override
  String get about => 'About';

  @override
  String get availablePromoCodes => 'Available Promo Codes';

  @override
  String useCodeForDiscount(String code, String discount) {
    return 'Use code $code for $discount% off!';
  }

  @override
  String remainingCount(String count) {
    return '$count remaining';
  }

  @override
  String get eventEnded => 'Event Ended';

  @override
  String get bookNow => 'Book Now';

  @override
  String get notAvailable => 'Not Available';

  @override
  String get myTickets => 'My Tickets';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noTicketsYet => 'No tickets yet.';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get payment => 'Payment';

  @override
  String get otpSentMessage =>
      'OTP has been sent to your registered mobile/email. (Default: 1234)';

  @override
  String get invalidOtpMessage => 'Invalid OTP. Please try again.';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get event => 'Event';

  @override
  String get ticket => 'Ticket';

  @override
  String categoryQuantity(String category, String quantity) {
    return '$category × $quantity';
  }

  @override
  String get subtotal => 'Subtotal';

  @override
  String promoCode(String code) {
    return 'Promo: $code';
  }

  @override
  String negativeNprAmount(String amount) {
    return '- NPR $amount';
  }

  @override
  String get totalToPay => 'Total to Pay';

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get card => 'Card';

  @override
  String get esewa => 'eSewa';

  @override
  String get pay => 'Pay';

  @override
  String get enterOtpToConfirm => 'Enter OTP to Confirm Payment';

  @override
  String get otpLabel => 'OTP : 1234';

  @override
  String verifyAndPay(String amount) {
    return 'Verify & Pay – NPR $amount';
  }

  @override
  String get maxSeatsAllowed => 'Maximum 10 seats allowed per booking.';

  @override
  String get chooseTicketCategoryFirst => 'Choose Ticket Category First';

  @override
  String categoryPrice(String category, String price) {
    return '$category (NPR $price)';
  }

  @override
  String get selected => 'Selected';

  @override
  String get booked => 'Booked';

  @override
  String get pleaseSelectCategory =>
      'Please select a ticket category to choose seats';

  @override
  String get stageUpper => 'STAGE';

  @override
  String get controlRoomUpper => 'CONTROL ROOM';

  @override
  String seatsSelected(String count) {
    return '$count seat(s) selected';
  }

  @override
  String get continueAction => 'Continue';

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
  String get ticketType => 'Ticket Type';

  @override
  String get quantity => 'Quantity';

  @override
  String get section => 'Section';

  @override
  String get discount => 'Discount';

  @override
  String get totalPaid => 'Total Paid';

  @override
  String get bookedOn => 'Booked On';

  @override
  String get reference => 'Reference';

  @override
  String get scanQrAtEntry => 'Scan this QR at entry';

  @override
  String generatedBy(String date) {
    return 'Generated by Eventopia on $date';
  }

  @override
  String get ticketConfirmed => 'Ticket Confirmed!';

  @override
  String get showQrAtEntry => 'Show this QR code at entry';

  @override
  String promoApplied(String discount) {
    return 'Code applied! $discount% discount';
  }

  @override
  String get invalidPromoCode => 'Invalid or expired code';

  @override
  String get bookingFailed => 'Booking failed. Please try again.';

  @override
  String get selectTicketType => 'Select Ticket Type';

  @override
  String countLeft(String count) {
    return '$count left';
  }

  @override
  String get apply => 'Apply';

  @override
  String discountWithPercent(String discount) {
    return 'Discount ($discount%)';
  }

  @override
  String get total => 'Total';

  @override
  String get selectATicketType => 'Select a ticket type';

  @override
  String get proceedToPay => 'Proceed to pay';

  @override
  String get eventSoldOut => 'This event is sold out.';

  @override
  String get onWaitlist => 'You\'re on the waitlist!';

  @override
  String get joinWaitlistDesc =>
      'Join the waitlist — we\'ll notify you when tickets become available.';

  @override
  String get joinWaitlist => 'Join Waitlist';

  @override
  String quantityMultiplier(String quantity) {
    return '× $quantity';
  }

  @override
  String get downloadTicket => 'Download Ticket';

  @override
  String get bookingCancelledRefunded =>
      'This booking is cancelled. The refund has been done.';

  @override
  String get bookingCancelledRefundedSuccess =>
      'Booking cancelled. The refund has been done.';

  @override
  String get cannotCancelWindowPassed =>
      'Cannot cancel — 7-day window has passed.';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String ofTotalSeats(String total) {
    return 'of $total total seats';
  }

  @override
  String categorySalesProgress(String category, String sold) {
    return '$category: $sold tickets sold';
  }

  @override
  String get newBooking => 'New Booking';

  @override
  String newBookingMessage(String attendee, int quantity, String eventTitle) {
    return '$attendee • $quantity ticket(s) • $eventTitle';
  }

  @override
  String get ticketsAvailable => 'Tickets Available';

  @override
  String waitlistPosition(String position) {
    return 'Position $position';
  }

  @override
  String get eventStatusUpdated => 'Event Status Updated';

  @override
  String eventApprovedByAdmin(String eventTitle) {
    return 'Your event \"$eventTitle\" has been approved by an admin.';
  }

  @override
  String eventStatusChanged(String eventTitle, String status) {
    return 'Your event \"$eventTitle\" is now $status.';
  }
}
