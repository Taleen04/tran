// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart' as intl;

// import 'app_localizations_ar.dart';
// import 'app_localizations_en.dart';

// // ignore_for_file: type=lint

// /// Callers can lookup localized strings with an instance of AppLocalizations
// /// returned by `AppLocalizations.of(context)`.
// ///
// /// Applications need to include `AppLocalizations.delegate()` in their app's
// /// `localizationDelegates` list, and the locales they support in the app's
// /// `supportedLocales` list. For example:
// ///
// /// ```dart
// /// import 'l10n/app_localizations.dart';
// ///
// /// return MaterialApp(
// ///   localizationsDelegates: AppLocalizations.localizationsDelegates,
// ///   supportedLocales: AppLocalizations.supportedLocales,
// ///   home: MyApplicationHome(),
// /// );
// /// ```
// ///
// /// ## Update pubspec.yaml
// ///
// /// Please make sure to update your pubspec.yaml to include the following
// /// packages:
// ///
// /// ```yaml
// /// dependencies:
// ///   # Internationalization support.
// ///   flutter_localizations:
// ///     sdk: flutter
// ///   intl: any # Use the pinned version from flutter_localizations
// ///
// ///   # Rest of dependencies
// /// ```
// ///
// /// ## iOS Applications
// ///
// /// iOS applications define key application metadata, including supported
// /// locales, in an Info.plist file that is built into the application bundle.
// /// To configure the locales supported by your app, you’ll need to edit this
// /// file.
// ///
// /// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
// /// Then, in the Project Navigator, open the Info.plist file under the Runner
// /// project’s Runner folder.
// ///
// /// Next, select the Information Property List item, select Add Item from the
// /// Editor menu, then select Localizations from the pop-up menu.
// ///
// /// Select and expand the newly-created Localizations item then, for each
// /// locale your application supports, add a new item and select the locale
// /// you wish to add from the pop-up menu in the Value field. This list should
// /// be consistent with the languages listed in the AppLocalizations.supportedLocales
// /// property.
// abstract class AppLocalizations {
//   AppLocalizations(String locale)
//     : localeName = intl.Intl.canonicalizedLocale(locale.toString());

//   final String localeName;

//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }

//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   /// A list of this localizations delegate along with the default localizations
//   /// delegates.
//   ///
//   /// Returns a list of localizations delegates containing this delegate along with
//   /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
//   /// and GlobalWidgetsLocalizations.delegate.
//   ///
//   /// Additional delegates can be added by appending to this list in
//   /// MaterialApp. This list does not have to be used at all if a custom list
//   /// of delegates is preferred or required.
//   static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
//       <LocalizationsDelegate<dynamic>>[
//         delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//       ];

//   /// A list of this localizations delegate's supported locales.
//   static const List<Locale> supportedLocales = <Locale>[
//     Locale('ar'),
//     Locale('en'),
//   ];

//   /// No description provided for @welcome.
//   ///
//   /// In en, this message translates to:
//   /// **'Welcome'**
//   String get welcome;

//   /// No description provided for @loginTitle.
//   ///
//   /// In en, this message translates to:
//   /// **'Login'**
//   String get loginTitle;

//   String get updateProfile;

//   /// No description provided for @enterPhone.
//   ///
//   /// In en, this message translates to:
//   /// **'Phone Number'**
//   String get enterPhone;

//   /// No description provided for @personalInformation.
//   ///
//   /// In en, this message translates to:
//   /// **'Personal Information'**
//   String get personalInformation;

//   /// No description provided for @enterPassword.
//   ///
//   /// In en, this message translates to:
//   /// **'Password'**
//   String get enterPassword;

//   /// No description provided for @loginButton.
//   ///
//   /// In en, this message translates to:
//   /// **'Login'**
//   String get loginButton;

//   /// No description provided for @phoneNumber.
//   ///
//   /// In en, this message translates to:
//   /// **'Phone Number'**
//   String get phoneNumber;

//   /// No description provided for @certificateOfNoCriminalRecord.
//   ///
//   /// In en, this message translates to:
//   /// **'Certificate Of No Criminal Record'**
//   String get certificateOfNoCriminalRecord;

//   /// No description provided for @changeLanguage.
//   ///
//   /// In en, this message translates to:
//   /// **'Change Language'**
//   String get changeLanguage;

//   /// No description provided for @changePassword.
//   ///
//   /// In en, this message translates to:
//   /// **'Change Password'**
//   String get changePassword;

//   /// No description provided for @changeWorkStatus.
//   ///
//   /// In en, this message translates to:
//   /// **'Change Work Status'**
//   String get changeWorkStatus;

//   /// No description provided for @conditionsAndPrivacy.
//   ///
//   /// In en, this message translates to:
//   /// **'Conditions And Privacy'**
//   String get conditionsAndPrivacy;

//   /// No description provided for @currentBalance.
//   ///
//   /// In en, this message translates to:
//   /// **'Current Balance'**
//   String get currentBalance;

//   /// No description provided for @currentReports.
//   ///
//   /// In en, this message translates to:
//   /// **'Current Reports'**
//   String get currentReports;

//   /// No description provided for @documents.
//   ///
//   /// In en, this message translates to:
//   /// **'Documents'**
//   String get documents;

//   /// No description provided for @done.
//   ///
//   /// In en, this message translates to:
//   /// **'Done'**
//   String get done;

//   /// No description provided for @expireReports.
//   ///
//   /// In en, this message translates to:
//   /// **'Expire Reports'**
//   String get expireReports;

//   /// No description provided for @hisOwnWallet.
//   ///
//   /// In en, this message translates to:
//   /// **'His Own Wallet'**
//   String get hisOwnWallet;

//   /// No description provided for @id.
//   ///
//   /// In en, this message translates to:
//   /// **'Id'**
//   String get id;

//   /// No description provided for @logout.
//   ///
//   /// In en, this message translates to:
//   /// **'Logout'**
//   String get logout;

//   /// No description provided for @recordsAndReports.
//   ///
//   /// In en, this message translates to:
//   /// **'Records And Reports'**
//   String get recordsAndReports;

//   /// No description provided for @setting.
//   ///
//   /// In en, this message translates to:
//   /// **'Setting'**
//   String get setting;

//   /// No description provided for @showDetails.
//   ///
//   /// In en, this message translates to:
//   /// **'Show Details'**
//   String get showDetails;

//   /// No description provided for @tripRecords.
//   ///
//   /// In en, this message translates to:
//   /// **'Trip Records'**
//   String get tripRecords;

//   /// No description provided for @vehicleLicense.
//   ///
//   /// In en, this message translates to:
//   /// **'Vehicle License'**
//   String get vehicleLicense;

//   /// No description provided for @wallet.
//   ///
//   /// In en, this message translates to:
//   /// **'Wallet'**
//   String get wallet;

//   /// No description provided for @address.
//   ///
//   /// In en, this message translates to:
//   /// **'address'**
//   String get address;

//   /// No description provided for @email.
//   ///
//   /// In en, this message translates to:
//   /// **'email'**
//   String get email;

//   /// No description provided for @vehicleType.
//   ///
//   /// In en, this message translates to:
//   /// **'vehicle Type'**
//   String get vehicleType;

//   /// No description provided for @areYouSureYouWantToLogOut.
//   ///
//   /// In en, this message translates to:
//   /// **'Are You Sure You Want To LogOut'**
//   String get areYouSureYouWantToLogOut;

//   /// No description provided for @cancel.
//   ///
//   /// In en, this message translates to:
//   /// **'cancel'**
//   String get cancel;

//   /// No description provided for @forgotPassword.
//   ///
//   /// In en, this message translates to:
//   /// **'Forgot Password?'**
//   String get forgotPassword;

//   /// No description provided for @enterYourPassword.
//   ///
//   /// In en, this message translates to:
//   /// **'Password'**
//   String get enterYourPassword;

//   /// No description provided for @enterPhoneNumber.
//   ///
//   /// In en, this message translates to:
//   /// **'Phone Number'**
//   String get enterPhoneNumber;
// }

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   Future<AppLocalizations> load(Locale locale) {
//     return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
//   }

//   @override
//   bool isSupported(Locale locale) =>
//       <String>['ar', 'en'].contains(locale.languageCode);

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }

// AppLocalizations lookupAppLocalizations(Locale locale) {
//   // Lookup logic when only language code is specified.
//   switch (locale.languageCode) {
//     case 'ar':
//       return AppLocalizationsAr();
//     case 'en':
//       return AppLocalizationsEn();
//   }

//   throw FlutterError(
//     'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
//     'an issue with the localizations generation tool. Please file an issue '
//     'on GitHub with a reproducible sample app and the gen-l10n configuration '
//     'that was used.',
//   );
// }
