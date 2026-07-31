import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ne')
  ];

  /// No description provided for @whatsPoppin.
  ///
  /// In en, this message translates to:
  /// **'What\'s Poppin\' at HELP?'**
  String get whatsPoppin;

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'SOLD OUT'**
  String get soldOut;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// Text for seatsLeft
  ///
  /// In en, this message translates to:
  /// **'{seats} left'**
  String seatsLeft(String seats);

  /// Text for fromNpr
  ///
  /// In en, this message translates to:
  /// **'From NPR {price}'**
  String fromNpr(String price);

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @attendee.
  ///
  /// In en, this message translates to:
  /// **'Attendee'**
  String get attendee;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// Text for passwordStrength
  ///
  /// In en, this message translates to:
  /// **'Password strength: {label}'**
  String passwordStrength(String label);

  /// No description provided for @changeDefaultPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please change your default password to continue.'**
  String get changeDefaultPasswordPrompt;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Eventopia'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @toggleVisibility.
  ///
  /// In en, this message translates to:
  /// **'Show/Hide Password'**
  String get toggleVisibility;

  /// No description provided for @loginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @joinEventopia.
  ///
  /// In en, this message translates to:
  /// **'Join Eventopia'**
  String get joinEventopia;

  /// No description provided for @registeringAs.
  ///
  /// In en, this message translates to:
  /// **'Registering as: '**
  String get registeringAs;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

  /// No description provided for @nameIsTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameIsTooShort;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneIsRequired;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @minimumSixChars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minimumSixChars;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?  '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @eventRequests.
  ///
  /// In en, this message translates to:
  /// **'Event Requests'**
  String get eventRequests;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get noPendingRequests;

  /// Text for byOrganizer
  ///
  /// In en, this message translates to:
  /// **'By {organizer}'**
  String byOrganizer(String organizer);

  /// No description provided for @eventRejected.
  ///
  /// In en, this message translates to:
  /// **'Event rejected'**
  String get eventRejected;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @eventApproved.
  ///
  /// In en, this message translates to:
  /// **'Event approved'**
  String get eventApproved;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @noUserLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No user logged in'**
  String get noUserLoggedIn;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @organisers.
  ///
  /// In en, this message translates to:
  /// **'Organisers'**
  String get organisers;

  /// No description provided for @attendees.
  ///
  /// In en, this message translates to:
  /// **'Attendees'**
  String get attendees;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// Text for nprRevenue
  ///
  /// In en, this message translates to:
  /// **'NPR {revenue}'**
  String nprRevenue(String revenue);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @addOrganiser.
  ///
  /// In en, this message translates to:
  /// **'Add\nOrganiser'**
  String get addOrganiser;

  /// No description provided for @eventRequestsQuickAction.
  ///
  /// In en, this message translates to:
  /// **'Event\nRequests'**
  String get eventRequestsQuickAction;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All Events'**
  String get allEvents;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @auditoriumOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Auditorium Occupancy'**
  String get auditoriumOccupancy;

  /// Text for seatsBooked
  ///
  /// In en, this message translates to:
  /// **'{booked} / {total} seats booked'**
  String seatsBooked(String booked, String total);

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @eventopiaAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Eventopia Analytics'**
  String get eventopiaAnalytics;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'REPORT'**
  String get report;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// Text for nameDetail
  ///
  /// In en, this message translates to:
  /// **'Name: {name}'**
  String nameDetail(String name);

  /// Text for dateDetail
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateDetail(String date);

  /// Text for organizerDetail
  ///
  /// In en, this message translates to:
  /// **'Organizer: {organizer}'**
  String organizerDetail(String organizer);

  /// Text for locationDetail
  ///
  /// In en, this message translates to:
  /// **'Location: {location}'**
  String locationDetail(String location);

  /// No description provided for @kpi.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators'**
  String get kpi;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @totalTicketsSold.
  ///
  /// In en, this message translates to:
  /// **'Total Tickets Sold'**
  String get totalTicketsSold;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @occupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get occupancyRate;

  /// No description provided for @occupancyProgress.
  ///
  /// In en, this message translates to:
  /// **'{title} occupancy {percent}%'**
  String occupancyProgress(String title, String percent);

  /// No description provided for @availableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get availableSeats;

  /// No description provided for @salesByTicketCategory.
  ///
  /// In en, this message translates to:
  /// **'Sales by Ticket Category'**
  String get salesByTicketCategory;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @ticketsSold.
  ///
  /// In en, this message translates to:
  /// **'Tickets Sold'**
  String get ticketsSold;

  /// Text for generatedOnBySystem
  ///
  /// In en, this message translates to:
  /// **'Generated on {date} by Eventopia System'**
  String generatedOnBySystem(String date);

  /// Text for failedToGeneratePdf
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF: {error}'**
  String failedToGeneratePdf(String error);

  /// No description provided for @reportsAndAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsAndAnalytics;

  /// No description provided for @noEventsToShowAnalytics.
  ///
  /// In en, this message translates to:
  /// **'No events available to show analytics.'**
  String get noEventsToShowAnalytics;

  /// No description provided for @selectEvent.
  ///
  /// In en, this message translates to:
  /// **'Select Event'**
  String get selectEvent;

  /// Text for ofTotal
  ///
  /// In en, this message translates to:
  /// **'of {total} total'**
  String ofTotal(String total);

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @sevenDayRevenue.
  ///
  /// In en, this message translates to:
  /// **'7-Day Revenue'**
  String get sevenDayRevenue;

  /// No description provided for @salesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Sales by Category'**
  String get salesByCategory;

  /// No description provided for @passwordChangedPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully. Please login.'**
  String get passwordChangedPleaseLogin;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @enterNewPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password below to secure your account.'**
  String get enterNewPasswordDesc;

  /// Text for entryApprovedFor
  ///
  /// In en, this message translates to:
  /// **'Entry approved for \"{title}\"'**
  String entryApprovedFor(String title);

  /// No description provided for @qrCodeNotFound.
  ///
  /// In en, this message translates to:
  /// **'QR code not found or already used.'**
  String get qrCodeNotFound;

  /// No description provided for @qrCheckIn.
  ///
  /// In en, this message translates to:
  /// **'QR Check-In'**
  String get qrCheckIn;

  /// No description provided for @scanQrAtGate.
  ///
  /// In en, this message translates to:
  /// **'Scan QR at entry gate'**
  String get scanQrAtGate;

  /// No description provided for @manualQrCodeEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual QR Code Entry'**
  String get manualQrCodeEntry;

  /// No description provided for @enterQrCode.
  ///
  /// In en, this message translates to:
  /// **'Enter QR Code'**
  String get enterQrCode;

  /// No description provided for @validateEntry.
  ///
  /// In en, this message translates to:
  /// **'Validate Entry'**
  String get validateEntry;

  /// No description provided for @noEventsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No events available'**
  String get noEventsAvailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// Text for areYouSureDeleteUser
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String areYouSureDeleteUser(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @organisation.
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get organisation;

  /// No description provided for @manageEvent.
  ///
  /// In en, this message translates to:
  /// **'Manage Event'**
  String get manageEvent;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteEvent;

  /// No description provided for @areYouSureDeleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event? This action cannot be undone.'**
  String get areYouSureDeleteEvent;

  /// No description provided for @eventRequestCard.
  ///
  /// In en, this message translates to:
  /// **'Event request card'**
  String get eventRequestCard;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save '**
  String get saveChanges;

  /// No description provided for @scanAttendeeQr.
  ///
  /// In en, this message translates to:
  /// **'Scan Attendee QR'**
  String get scanAttendeeQr;

  /// No description provided for @cameraOpensHere.
  ///
  /// In en, this message translates to:
  /// **'Camera opens here'**
  String get cameraOpensHere;

  /// No description provided for @mobileScannerPlugin.
  ///
  /// In en, this message translates to:
  /// **'(mobile_scanner plugin)'**
  String get mobileScannerPlugin;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @organiserRegistered.
  ///
  /// In en, this message translates to:
  /// **'Organiser Registered!'**
  String get organiserRegistered;

  /// No description provided for @organiserLoginCredentialsAssigned.
  ///
  /// In en, this message translates to:
  /// **'Login credentials have been assigned to the organiser. They can use the default password (Org@1234) and change it on first login.'**
  String get organiserLoginCredentialsAssigned;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @registerNewOrganiser.
  ///
  /// In en, this message translates to:
  /// **'Register New Organiser'**
  String get registerNewOrganiser;

  /// No description provided for @defaultPasswordAssignedDesc.
  ///
  /// In en, this message translates to:
  /// **'A default password (Org@1234) will be assigned and emailed to the organiser. They must change it on first login.'**
  String get defaultPasswordAssignedDesc;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @organisationNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Organisation Name (optional)'**
  String get organisationNameOptional;

  /// No description provided for @registerOrganiser.
  ///
  /// In en, this message translates to:
  /// **'Register Organiser'**
  String get registerOrganiser;

  /// No description provided for @myEvents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get myEvents;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @organiser.
  ///
  /// In en, this message translates to:
  /// **'Organiser'**
  String get organiser;

  /// Text for nprParam
  ///
  /// In en, this message translates to:
  /// **'NPR {param}'**
  String nprParam(String param);

  /// No description provided for @promoCodes.
  ///
  /// In en, this message translates to:
  /// **'Promo Codes'**
  String get promoCodes;

  /// No description provided for @createAction.
  ///
  /// In en, this message translates to:
  /// **'+ Create'**
  String get createAction;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get noEventsYet;

  /// No description provided for @tapCreateToAddFirstEvent.
  ///
  /// In en, this message translates to:
  /// **'Tap \"+ Create\" to add your first event.'**
  String get tapCreateToAddFirstEvent;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @eventAnalyticsReport.
  ///
  /// In en, this message translates to:
  /// **'EVENT ANALYTICS REPORT'**
  String get eventAnalyticsReport;

  /// Text for nameParam
  ///
  /// In en, this message translates to:
  /// **'Name: {param}'**
  String nameParam(String param);

  /// Text for dateParam
  ///
  /// In en, this message translates to:
  /// **'Date: {param}'**
  String dateParam(String param);

  /// No description provided for @kpis.
  ///
  /// In en, this message translates to:
  /// **'Key Performance Indicators (KPIs)'**
  String get kpis;

  /// No description provided for @generatedBySystem.
  ///
  /// In en, this message translates to:
  /// **'Generated by Eventopia System'**
  String get generatedBySystem;

  /// No description provided for @createEventsToSeeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Create events to see analytics.'**
  String get createEventsToSeeAnalytics;

  /// No description provided for @downloadPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Report'**
  String get downloadPdfReport;

  /// Text for ofParamTotal
  ///
  /// In en, this message translates to:
  /// **'of {param} total'**
  String ofParamTotal(String param);

  /// No description provided for @ticketVerified.
  ///
  /// In en, this message translates to:
  /// **'Ticket Verified'**
  String get ticketVerified;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailed;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @scanTicket.
  ///
  /// In en, this message translates to:
  /// **'Scan Ticket'**
  String get scanTicket;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @eventAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Event has been added successfully!'**
  String get eventAddedSuccessfully;

  /// No description provided for @createNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Create New Event'**
  String get createNewEvent;

  /// No description provided for @eventPoster.
  ///
  /// In en, this message translates to:
  /// **'Event Poster'**
  String get eventPoster;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @tapToAddEventPoster.
  ///
  /// In en, this message translates to:
  /// **'Tap to add event poster'**
  String get tapToAddEventPoster;

  /// No description provided for @recommendedPosterSize.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 1200 × 800 px'**
  String get recommendedPosterSize;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get eventTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @ticketCategories.
  ///
  /// In en, this message translates to:
  /// **'Ticket Categories'**
  String get ticketCategories;

  /// No description provided for @priceNpr.
  ///
  /// In en, this message translates to:
  /// **'Price (NPR)'**
  String get priceNpr;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @promoCodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Promo Code (Optional)'**
  String get promoCodeOptional;

  /// No description provided for @codeExample.
  ///
  /// In en, this message translates to:
  /// **'Code (e.g. SAVE20)'**
  String get codeExample;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get discountPercentage;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// Text for minParam
  ///
  /// In en, this message translates to:
  /// **'Min {param}'**
  String minParam(String param);

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @ticketTypes.
  ///
  /// In en, this message translates to:
  /// **'Ticket Types'**
  String get ticketTypes;

  /// Text for paramOff
  ///
  /// In en, this message translates to:
  /// **'{param}% off'**
  String paramOff(String param);

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @discoverConnectCelebrate.
  ///
  /// In en, this message translates to:
  /// **'Discover. Connect. Celebrate.'**
  String get discoverConnectCelebrate;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// Text for nprAmount
  ///
  /// In en, this message translates to:
  /// **'NPR {amount}'**
  String nprAmount(String amount);

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Events'**
  String get upcomingEvents;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events.'**
  String get noUpcomingEvents;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @exploreEvents.
  ///
  /// In en, this message translates to:
  /// **'Explore Events'**
  String get exploreEvents;

  /// No description provided for @searchEvents.
  ///
  /// In en, this message translates to:
  /// **'Search events…'**
  String get searchEvents;

  /// No description provided for @noEventsMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No events match your search.'**
  String get noEventsMatchSearch;

  /// No description provided for @eventUpper.
  ///
  /// In en, this message translates to:
  /// **'EVENT'**
  String get eventUpper;

  /// No description provided for @completedUpper.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get completedUpper;

  /// No description provided for @upcomingUpper.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get upcomingUpper;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @availablePromoCodes.
  ///
  /// In en, this message translates to:
  /// **'Available Promo Codes'**
  String get availablePromoCodes;

  /// Text for useCodeForDiscount
  ///
  /// In en, this message translates to:
  /// **'Use code {code} for {discount}% off!'**
  String useCodeForDiscount(String code, String discount);

  /// Text for remainingCount
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String remainingCount(String count);

  /// No description provided for @eventEnded.
  ///
  /// In en, this message translates to:
  /// **'Event Ended'**
  String get eventEnded;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @myTickets.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get myTickets;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet.'**
  String get noTicketsYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to your registered mobile/email. (Default: 1234)'**
  String get otpSentMessage;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtpMessage;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @ticket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get ticket;

  /// Text for categoryQuantity
  ///
  /// In en, this message translates to:
  /// **'{category} × {quantity}'**
  String categoryQuantity(String category, String quantity);

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Text for promoCode
  ///
  /// In en, this message translates to:
  /// **'Promo: {code}'**
  String promoCode(String code);

  /// Text for negativeNprAmount
  ///
  /// In en, this message translates to:
  /// **'- NPR {amount}'**
  String negativeNprAmount(String amount);

  /// No description provided for @totalToPay.
  ///
  /// In en, this message translates to:
  /// **'Total to Pay'**
  String get totalToPay;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @esewa.
  ///
  /// In en, this message translates to:
  /// **'eSewa'**
  String get esewa;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @enterOtpToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP to Confirm Payment'**
  String get enterOtpToConfirm;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP : 1234'**
  String get otpLabel;

  /// Text for verifyAndPay
  ///
  /// In en, this message translates to:
  /// **'Verify & Pay – NPR {amount}'**
  String verifyAndPay(String amount);

  /// No description provided for @maxSeatsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 seats allowed per booking.'**
  String get maxSeatsAllowed;

  /// No description provided for @chooseTicketCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose Ticket Category First'**
  String get chooseTicketCategoryFirst;

  /// Text for categoryPrice
  ///
  /// In en, this message translates to:
  /// **'{category} (NPR {price})'**
  String categoryPrice(String category, String price);

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a ticket category to choose seats'**
  String get pleaseSelectCategory;

  /// No description provided for @stageUpper.
  ///
  /// In en, this message translates to:
  /// **'STAGE'**
  String get stageUpper;

  /// No description provided for @controlRoomUpper.
  ///
  /// In en, this message translates to:
  /// **'CONTROL ROOM'**
  String get controlRoomUpper;

  /// Text for seatsSelected
  ///
  /// In en, this message translates to:
  /// **'{count} seat(s) selected'**
  String seatsSelected(String count);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @eventopiaUpper.
  ///
  /// In en, this message translates to:
  /// **'EVENTOPIA'**
  String get eventopiaUpper;

  /// No description provided for @eTicketUpper.
  ///
  /// In en, this message translates to:
  /// **'E-TICKET'**
  String get eTicketUpper;

  /// No description provided for @confirmedUpper.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get confirmedUpper;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @ticketType.
  ///
  /// In en, this message translates to:
  /// **'Ticket Type'**
  String get ticketType;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @bookedOn.
  ///
  /// In en, this message translates to:
  /// **'Booked On'**
  String get bookedOn;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @scanQrAtEntry.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR at entry'**
  String get scanQrAtEntry;

  /// Text for generatedBy
  ///
  /// In en, this message translates to:
  /// **'Generated by Eventopia on {date}'**
  String generatedBy(String date);

  /// No description provided for @ticketConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Ticket Confirmed!'**
  String get ticketConfirmed;

  /// No description provided for @showQrAtEntry.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code at entry'**
  String get showQrAtEntry;

  /// Text for promoApplied
  ///
  /// In en, this message translates to:
  /// **'Code applied! {discount}% discount'**
  String promoApplied(String discount);

  /// No description provided for @invalidPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code'**
  String get invalidPromoCode;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed. Please try again.'**
  String get bookingFailed;

  /// No description provided for @selectTicketType.
  ///
  /// In en, this message translates to:
  /// **'Select Ticket Type'**
  String get selectTicketType;

  /// Text for countLeft
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String countLeft(String count);

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Text for discountWithPercent
  ///
  /// In en, this message translates to:
  /// **'Discount ({discount}%)'**
  String discountWithPercent(String discount);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @selectATicketType.
  ///
  /// In en, this message translates to:
  /// **'Select a ticket type'**
  String get selectATicketType;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay'**
  String get proceedToPay;

  /// No description provided for @eventSoldOut.
  ///
  /// In en, this message translates to:
  /// **'This event is sold out.'**
  String get eventSoldOut;

  /// No description provided for @onWaitlist.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the waitlist!'**
  String get onWaitlist;

  /// No description provided for @joinWaitlistDesc.
  ///
  /// In en, this message translates to:
  /// **'Join the waitlist — we\'ll notify you when tickets become available.'**
  String get joinWaitlistDesc;

  /// No description provided for @joinWaitlist.
  ///
  /// In en, this message translates to:
  /// **'Join Waitlist'**
  String get joinWaitlist;

  /// Text for quantityMultiplier
  ///
  /// In en, this message translates to:
  /// **'× {quantity}'**
  String quantityMultiplier(String quantity);

  /// No description provided for @downloadTicket.
  ///
  /// In en, this message translates to:
  /// **'Download Ticket'**
  String get downloadTicket;

  /// No description provided for @bookingCancelledRefunded.
  ///
  /// In en, this message translates to:
  /// **'This booking is cancelled. The refund has been done.'**
  String get bookingCancelledRefunded;

  /// No description provided for @bookingCancelledRefundedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled. The refund has been done.'**
  String get bookingCancelledRefundedSuccess;

  /// No description provided for @cannotCancelWindowPassed.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel — 7-day window has passed.'**
  String get cannotCancelWindowPassed;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Text for ofTotalSeats
  ///
  /// In en, this message translates to:
  /// **'of {total} total seats'**
  String ofTotalSeats(String total);

  /// Accessibility label for sales progress
  ///
  /// In en, this message translates to:
  /// **'{category}: {sold} tickets sold'**
  String categorySalesProgress(String category, String sold);

  /// No description provided for @newBooking.
  ///
  /// In en, this message translates to:
  /// **'New Booking'**
  String get newBooking;

  /// No description provided for @newBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'{attendee} • {quantity} ticket(s) • {eventTitle}'**
  String newBookingMessage(String attendee, int quantity, String eventTitle);

  /// No description provided for @ticketsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Tickets Available'**
  String get ticketsAvailable;

  /// No description provided for @waitlistPosition.
  ///
  /// In en, this message translates to:
  /// **'Position {position}'**
  String waitlistPosition(String position);

  /// No description provided for @eventStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event Status Updated'**
  String get eventStatusUpdated;

  /// No description provided for @eventApprovedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Your event \"{eventTitle}\" has been approved by an admin.'**
  String eventApprovedByAdmin(String eventTitle);

  /// No description provided for @eventStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Your event \"{eventTitle}\" is now {status}.'**
  String eventStatusChanged(String eventTitle, String status);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
