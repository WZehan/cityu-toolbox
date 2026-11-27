// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sourceCode => 'GitHub source';

  @override
  String get aboutAuthor => 'About the author';

  @override
  String get selectLanguage => 'Language';

  @override
  String get appName => 'CityU Toolbox';

  @override
  String get all => 'All';

  @override
  String get dining => 'Dining';

  @override
  String get study => 'Study';

  @override
  String get searchTools => 'Search tools';

  @override
  String get clear => 'Clear';

  @override
  String get noTools => 'No matching tools found';

  @override
  String get more => 'More';

  @override
  String get addToHomeScreen => 'Add to Home Screen';

  @override
  String get installSubtitle => 'Open from your home screen like an app';

  @override
  String homeFooter(String version) {
    return 'CityU Toolbox · Build $version\nAn independent student utility, not an official City University of Hong Kong app';
  }

  @override
  String get ac1Title => 'AC1 City Express';

  @override
  String get ac1Subtitle => 'City Express · Order online';

  @override
  String get ac2Subtitle => '7 stalls · 4 offer online ordering';

  @override
  String get onlineOrdering => 'Order online';

  @override
  String get onSiteOrdering => 'Order at the stall';

  @override
  String get ac1Location => '5/F, Bank of China (Hong Kong) Complex';

  @override
  String get ac2Location => '3/F, Li Dak Sum Yip Yio Chin Academic Building';

  @override
  String get ac3Location => '7/F, Lau Ming Wai Academic Building';

  @override
  String get dailyHours => 'Mon–Sun 07:30–21:00';

  @override
  String get weekdayHours => 'Mon–Sat 07:30–21:00';

  @override
  String get holidayClosed => 'Closed on Sundays and public holidays';

  @override
  String get libraryResources => 'Library Resources';

  @override
  String get librarySubtitle =>
      'Catalogue search, JULAC, databases and past exam papers';

  @override
  String get publicResources => 'Public Resource Booking';

  @override
  String get publicResourcesSubtitle =>
      'Browse and book shared campus resources';

  @override
  String get sportsBooking => 'Sports Facility Booking';

  @override
  String get sportsSubtitle => 'Book sports venues and facilities';

  @override
  String get testimonial => 'Testimonial Pre-fill';

  @override
  String get testimonialSubtitle =>
      'Prepare your details, then preview and copy';

  @override
  String get searchCatalogue => 'Search the catalogue';

  @override
  String get catalogueHint => 'Title, author, subject or keywords';

  @override
  String get search => 'Search';

  @override
  String get commonResources => 'Useful resources';

  @override
  String get julacTitle => 'JULAC Application';

  @override
  String get julacSubtitle =>
      'Apply for inter-library services at eight universities';

  @override
  String get academicResources => 'Academic Resources';

  @override
  String get academicSubtitle => 'Browse electronic databases by subject';

  @override
  String get pastPapers => 'Past Exam Papers';

  @override
  String get pastPapersSubtitle => 'Find and download past exam papers';

  @override
  String get orderNow => 'Order now';

  @override
  String get selectFood => 'Select food';

  @override
  String get payByWeight => 'Pay by weight';

  @override
  String get pickUp => 'Collect your food';

  @override
  String get queueUp => 'Queue up';

  @override
  String get chooseFood => 'Select food';

  @override
  String get settleBill => 'Settle the bill';

  @override
  String get placeOrder => 'Place your order';

  @override
  String get collectFood => 'Collect your food';

  @override
  String get teaHouse => 'Tea House';

  @override
  String get xibei => 'XiBei Mian Guan';

  @override
  String get dumplingCity => 'Dumpling City Express';

  @override
  String get malaRolling => 'Mala Rolling';

  @override
  String get thePick => 'The Pick';

  @override
  String get tastyCorner => 'Tasty Corner';

  @override
  String get studentName => 'Student name';

  @override
  String get studentNumber => 'Student number';

  @override
  String get contactPhone => 'Daytime contact number';

  @override
  String get identityNumber => 'HKID / passport number';

  @override
  String get programTitle => 'Programme title';

  @override
  String get department => 'Department';

  @override
  String get copiesRequired => 'Number of copies required';

  @override
  String get emailAddress => 'Email address';

  @override
  String requiredField(String field) {
    return 'Please enter $field';
  }

  @override
  String get positiveInteger => 'Enter a whole number greater than 0';

  @override
  String get validEmail => 'Enter a valid email address';

  @override
  String get validPhone => 'Enter a valid contact number';

  @override
  String get previewTitle => 'Preview your details';

  @override
  String get backToEdit => 'Back to edit';

  @override
  String get copiedDetails =>
      'Copied. Paste into the official application form.';

  @override
  String get copyFailed =>
      'Unable to copy. Select and copy the text in the preview.';

  @override
  String get copyAll => 'Copy all';

  @override
  String get clearFormTitle => 'Clear all entered details?';

  @override
  String get clearFormMessage => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clearForm => 'Clear form';

  @override
  String get clearConfirm => 'Clear';

  @override
  String get programHint => 'e.g. MSc Business Information Systems';

  @override
  String get formNotice =>
      'Preview and copy your details in English for the official application. This tool does not submit applications or issue testimonials. Your details stay on this page only.';

  @override
  String get basicInformation => 'Basic information';

  @override
  String feeReference(int amount) {
    return 'Reference fee: HK\$$amount / copy / programme';
  }

  @override
  String get feeDisclaimer =>
      'Subject to the university\'s latest published fees';

  @override
  String estimatedFee(int amount) {
    return 'Est. HK\$$amount';
  }

  @override
  String get optionalInformation => 'Optional information';

  @override
  String get contactAddress => 'Contact address in AIMS';

  @override
  String get mediumInstruction => 'Medium of instruction';

  @override
  String get previewAndCopy => 'Preview and copy details';

  @override
  String get installIntro =>
      'Open the website below in your browser and add it to your home screen for quick access.';

  @override
  String get urlCopied => 'Website address copied';

  @override
  String get copyUrl => 'Copy website address';

  @override
  String get otherBrowsers => 'Other browsers';

  @override
  String get otherBrowsersGuide =>
      'Look for Add to Home Screen or Install app in your browser\'s share menu or main menu, then follow the prompts. Wording and location vary by browser.';

  @override
  String get installStep1Title => 'Open the website and tap Share';

  @override
  String get installStep1Detail =>
      'Open CityU Toolbox in Safari and tap the Share button.';

  @override
  String get installStep2Title => 'Choose Add to Home Screen';

  @override
  String get installStep2Detail =>
      'Scroll down in the share menu and tap Add to Home Screen.';

  @override
  String get installStep3Title => 'Confirm the name and tap Add';

  @override
  String get installStep3Detail =>
      'Confirm the name, then tap Add. Open the app using the new home screen icon.';

  @override
  String enlargeScreenshot(int step, String title) {
    return 'Enlarge screenshot for step $step: $title';
  }

  @override
  String get close => 'Close';

  @override
  String get linkErrorTitle => 'Unable to open this link';

  @override
  String linkErrorMessage(String url) {
    return 'Copy this link and open it in your browser:\n$url';
  }
}
