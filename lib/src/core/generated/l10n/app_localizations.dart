import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // ---------------- Strings ----------------
  String get usernameOrEmailPlaceholder;
  String get passwordPlaceholder;
  String get loginTitle;
  String get personalInformation;
  String get phoneNumber;
  String get enterPhoneNumber;
  String get enterYourPassword;
  String get email;
  String get from;
  String get editOrder;
  String get to;
  String get orderStatus;
  String get busy;
  String get online;
  String get offline;
  String get ThereAreNoNotes;
  String get EnterYourPhoneNumber;
  String get WeWillSendYouAVerificationCode;
  String get address;
  String get SendVerificationCode;
  String get OrderList;
  String get ToDoList;
  String get LoginToContinueYourJourney;
  String get ForgetPassword;
  String get vehicleType;
  String get RecordsAndReports;
  String get TripRecords;
  String get CurrentReports;
  String get ExpireReports;
  String get Wallet;
  String get CurrentBalance;
  String get ShowDetails;
  String get cancel;
  String get AreYouSureYouWantToLogOut;
  String get Documents;
  String get VehicleLicense;
  String get changePassword;
  String get thePasswordMustContainACombinationOfNumbersLettersandSpecialSymbols;
  String get currentPassword;
  String get newPassword;
  String get Id;
  String get CertificateOfNoCriminalRecord;
  String get HisOwnWallet;
  String get Done;
  String get Setting;
  String get ChangeLanguage;
  String get ChangeWorkStatus;
  String get ConditionsAndPrivacy;
  String get ChangePassword;
  String get Logout;
  String get on;
  String get off;
  String get myAccount;
  String get home;
  String get chat;
  String get rememberMeText;
  String get forgotPasswordText;
  String get signInButtonText;
  String get noAccountText;
  String get createAccountLink;
  String get policyAgreementText;
  String get termsAndConditionsLink;
  String get businessRegistrationTitle;
  String get usernamePlaceholder;
  String get emailPlaceholder;
  String get commercialNamePlaceholder;
  String get phoneNumberPlaceholder;
  String get activityTypePlaceholder;
  String get countryPlaceholder;
  String get streetPlaceholder;
  String get locationPlaceholder;
  String get provincePlaceholder;
  String get websiteOptionalPlaceholder;
  String get adsCategoryPlaceholder;
  String get adsSubCategoryPlaceholder;
  String get businessLicensePlaceholder;
  String get sponsorCodeOptionalPlaceholder;
  String get confirmPasswordPlaceholder;
  String get signUpButtonText;
  String get forgetPasswordTitle;
  String get enterYourEmailLabel;
  String get submitButtonText;
  String get resetPasswordTitle;
  String get resetPasswordButtonText;
  String get doneTitle;
  String get goToHomePageButtonText;
  String get createAccountingTitle;
  String get accountingFieldPlaceholder;
  String get orText;
  String get selectForAllAccountsOption;
  String get namePlaceholder;
  String get userNamePlaceholder;
  String get saveButtonText;
  String get updateProfile;
  String get name;
  String get save;

}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
