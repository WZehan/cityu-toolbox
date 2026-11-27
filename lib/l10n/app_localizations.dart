import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get selectLanguage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CityU Toolbox'**
  String get appName;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @dining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get dining;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @searchTools.
  ///
  /// In en, this message translates to:
  /// **'Search tools'**
  String get searchTools;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noTools.
  ///
  /// In en, this message translates to:
  /// **'No matching tools found'**
  String get noTools;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @addToHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Add to Home Screen'**
  String get addToHomeScreen;

  /// No description provided for @installSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open from your home screen like an app'**
  String get installSubtitle;

  /// No description provided for @homeFooter.
  ///
  /// In en, this message translates to:
  /// **'CityU Toolbox · Build {version}\nAn independent student utility, not an official City University of Hong Kong app'**
  String homeFooter(String version);

  /// No description provided for @ac1Title.
  ///
  /// In en, this message translates to:
  /// **'AC1 City Express'**
  String get ac1Title;

  /// No description provided for @ac1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'City Express · Order online'**
  String get ac1Subtitle;

  /// No description provided for @ac2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'7 stalls · 4 offer online ordering'**
  String get ac2Subtitle;

  /// No description provided for @onlineOrdering.
  ///
  /// In en, this message translates to:
  /// **'Order online'**
  String get onlineOrdering;

  /// No description provided for @onSiteOrdering.
  ///
  /// In en, this message translates to:
  /// **'Order at the stall'**
  String get onSiteOrdering;

  /// No description provided for @ac1Location.
  ///
  /// In en, this message translates to:
  /// **'5/F, Bank of China (Hong Kong) Complex'**
  String get ac1Location;

  /// No description provided for @ac2Location.
  ///
  /// In en, this message translates to:
  /// **'3/F, Li Dak Sum Yip Yio Chin Academic Building'**
  String get ac2Location;

  /// No description provided for @ac3Location.
  ///
  /// In en, this message translates to:
  /// **'7/F, Lau Ming Wai Academic Building'**
  String get ac3Location;

  /// No description provided for @dailyHours.
  ///
  /// In en, this message translates to:
  /// **'Mon–Sun 07:30–21:00'**
  String get dailyHours;

  /// No description provided for @weekdayHours.
  ///
  /// In en, this message translates to:
  /// **'Mon–Sat 07:30–21:00'**
  String get weekdayHours;

  /// No description provided for @holidayClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed on Sundays and public holidays'**
  String get holidayClosed;

  /// No description provided for @libraryResources.
  ///
  /// In en, this message translates to:
  /// **'Library Resources'**
  String get libraryResources;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catalogue search, JULAC, databases and past exam papers'**
  String get librarySubtitle;

  /// No description provided for @publicResources.
  ///
  /// In en, this message translates to:
  /// **'Public Resource Booking'**
  String get publicResources;

  /// No description provided for @publicResourcesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse and book shared campus resources'**
  String get publicResourcesSubtitle;

  /// No description provided for @sportsBooking.
  ///
  /// In en, this message translates to:
  /// **'Sports Facility Booking'**
  String get sportsBooking;

  /// No description provided for @sportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book sports venues and facilities'**
  String get sportsSubtitle;

  /// No description provided for @testimonial.
  ///
  /// In en, this message translates to:
  /// **'Testimonial Pre-fill'**
  String get testimonial;

  /// No description provided for @testimonialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare your details, then preview and copy'**
  String get testimonialSubtitle;

  /// No description provided for @searchCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Search the catalogue'**
  String get searchCatalogue;

  /// No description provided for @catalogueHint.
  ///
  /// In en, this message translates to:
  /// **'Title, author, subject or keywords'**
  String get catalogueHint;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @commonResources.
  ///
  /// In en, this message translates to:
  /// **'Useful resources'**
  String get commonResources;

  /// No description provided for @julacTitle.
  ///
  /// In en, this message translates to:
  /// **'JULAC Application'**
  String get julacTitle;

  /// No description provided for @julacSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Apply for inter-library services at eight universities'**
  String get julacSubtitle;

  /// No description provided for @academicResources.
  ///
  /// In en, this message translates to:
  /// **'Academic Resources'**
  String get academicResources;

  /// No description provided for @academicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse electronic databases by subject'**
  String get academicSubtitle;

  /// No description provided for @pastPapers.
  ///
  /// In en, this message translates to:
  /// **'Past Exam Papers'**
  String get pastPapers;

  /// No description provided for @pastPapersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find and download past exam papers'**
  String get pastPapersSubtitle;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order now'**
  String get orderNow;

  /// No description provided for @selectFood.
  ///
  /// In en, this message translates to:
  /// **'Select food'**
  String get selectFood;

  /// No description provided for @payByWeight.
  ///
  /// In en, this message translates to:
  /// **'Pay by weight'**
  String get payByWeight;

  /// No description provided for @pickUp.
  ///
  /// In en, this message translates to:
  /// **'Collect your food'**
  String get pickUp;

  /// No description provided for @queueUp.
  ///
  /// In en, this message translates to:
  /// **'Queue up'**
  String get queueUp;

  /// No description provided for @chooseFood.
  ///
  /// In en, this message translates to:
  /// **'Select food'**
  String get chooseFood;

  /// No description provided for @settleBill.
  ///
  /// In en, this message translates to:
  /// **'Settle the bill'**
  String get settleBill;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place your order'**
  String get placeOrder;

  /// No description provided for @collectFood.
  ///
  /// In en, this message translates to:
  /// **'Collect your food'**
  String get collectFood;

  /// No description provided for @teaHouse.
  ///
  /// In en, this message translates to:
  /// **'Tea House'**
  String get teaHouse;

  /// No description provided for @xibei.
  ///
  /// In en, this message translates to:
  /// **'XiBei Mian Guan'**
  String get xibei;

  /// No description provided for @dumplingCity.
  ///
  /// In en, this message translates to:
  /// **'Dumpling City Express'**
  String get dumplingCity;

  /// No description provided for @malaRolling.
  ///
  /// In en, this message translates to:
  /// **'Mala Rolling'**
  String get malaRolling;

  /// No description provided for @thePick.
  ///
  /// In en, this message translates to:
  /// **'The Pick'**
  String get thePick;

  /// No description provided for @tastyCorner.
  ///
  /// In en, this message translates to:
  /// **'Tasty Corner'**
  String get tastyCorner;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get studentName;

  /// No description provided for @studentNumber.
  ///
  /// In en, this message translates to:
  /// **'Student number'**
  String get studentNumber;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Daytime contact number'**
  String get contactPhone;

  /// No description provided for @identityNumber.
  ///
  /// In en, this message translates to:
  /// **'HKID / passport number'**
  String get identityNumber;

  /// No description provided for @programTitle.
  ///
  /// In en, this message translates to:
  /// **'Programme title'**
  String get programTitle;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @copiesRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of copies required'**
  String get copiesRequired;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String requiredField(String field);

  /// No description provided for @positiveInteger.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number greater than 0'**
  String get positiveInteger;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validEmail;

  /// No description provided for @validPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid contact number'**
  String get validPhone;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview your details'**
  String get previewTitle;

  /// No description provided for @backToEdit.
  ///
  /// In en, this message translates to:
  /// **'Back to edit'**
  String get backToEdit;

  /// No description provided for @copiedDetails.
  ///
  /// In en, this message translates to:
  /// **'Copied. Paste into the official application form.'**
  String get copiedDetails;

  /// No description provided for @copyFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to copy. Select and copy the text in the preview.'**
  String get copyFailed;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get copyAll;

  /// No description provided for @clearFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all entered details?'**
  String get clearFormTitle;

  /// No description provided for @clearFormMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get clearFormMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clearForm.
  ///
  /// In en, this message translates to:
  /// **'Clear form'**
  String get clearForm;

  /// No description provided for @clearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearConfirm;

  /// No description provided for @programHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. MSc Business Information Systems'**
  String get programHint;

  /// No description provided for @formNotice.
  ///
  /// In en, this message translates to:
  /// **'Preview and copy your details in English for the official application. This tool does not submit applications or issue testimonials. Your details stay on this page only.'**
  String get formNotice;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get basicInformation;

  /// No description provided for @feeReference.
  ///
  /// In en, this message translates to:
  /// **'Reference fee: HK\${amount} / copy / programme'**
  String feeReference(int amount);

  /// No description provided for @feeDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Subject to the university\'s latest published fees'**
  String get feeDisclaimer;

  /// No description provided for @estimatedFee.
  ///
  /// In en, this message translates to:
  /// **'Est. HK\${amount}'**
  String estimatedFee(int amount);

  /// No description provided for @optionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Optional information'**
  String get optionalInformation;

  /// No description provided for @contactAddress.
  ///
  /// In en, this message translates to:
  /// **'Contact address in AIMS'**
  String get contactAddress;

  /// No description provided for @mediumInstruction.
  ///
  /// In en, this message translates to:
  /// **'Medium of instruction'**
  String get mediumInstruction;

  /// No description provided for @previewAndCopy.
  ///
  /// In en, this message translates to:
  /// **'Preview and copy details'**
  String get previewAndCopy;

  /// No description provided for @installIntro.
  ///
  /// In en, this message translates to:
  /// **'Open the website below in your browser and add it to your home screen for quick access.'**
  String get installIntro;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'Website address copied'**
  String get urlCopied;

  /// No description provided for @copyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy website address'**
  String get copyUrl;

  /// No description provided for @otherBrowsers.
  ///
  /// In en, this message translates to:
  /// **'Other browsers'**
  String get otherBrowsers;

  /// No description provided for @otherBrowsersGuide.
  ///
  /// In en, this message translates to:
  /// **'Look for Add to Home Screen or Install app in your browser\'s share menu or main menu, then follow the prompts. Wording and location vary by browser.'**
  String get otherBrowsersGuide;

  /// No description provided for @installStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open the website and tap Share'**
  String get installStep1Title;

  /// No description provided for @installStep1Detail.
  ///
  /// In en, this message translates to:
  /// **'Open CityU Toolbox in Safari and tap the Share button.'**
  String get installStep1Detail;

  /// No description provided for @installStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Choose Add to Home Screen'**
  String get installStep2Title;

  /// No description provided for @installStep2Detail.
  ///
  /// In en, this message translates to:
  /// **'Scroll down in the share menu and tap Add to Home Screen.'**
  String get installStep2Detail;

  /// No description provided for @installStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm the name and tap Add'**
  String get installStep3Title;

  /// No description provided for @installStep3Detail.
  ///
  /// In en, this message translates to:
  /// **'Confirm the name, then tap Add. Open the app using the new home screen icon.'**
  String get installStep3Detail;

  /// No description provided for @enlargeScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Enlarge screenshot for step {step}: {title}'**
  String enlargeScreenshot(int step, String title);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @linkErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link'**
  String get linkErrorTitle;

  /// No description provided for @linkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy this link and open it in your browser:\n{url}'**
  String linkErrorMessage(String url);
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
