import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Financely'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navTransactions;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @filterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get filterAllTime;

  /// No description provided for @filterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get filterThisMonth;

  /// No description provided for @filterLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get filterLast30Days;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get filterClear;

  /// No description provided for @filterNoResults.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this range'**
  String get filterNoResults;

  /// No description provided for @filterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get filterDateRange;

  /// No description provided for @currencyUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating exchange rates…'**
  String get currencyUpdating;

  /// No description provided for @currencyUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch exchange rates. Currency unchanged.'**
  String get currencyUpdateFailed;

  /// No description provided for @balanceTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get balanceTotalBalance;

  /// No description provided for @balanceIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get balanceIncome;

  /// No description provided for @balanceSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get balanceSpent;

  /// No description provided for @hideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide balance'**
  String get hideBalance;

  /// No description provided for @showBalance.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get showBalance;

  /// No description provided for @budgetMonthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get budgetMonthlyBudget;

  /// No description provided for @budgetSpent.
  ///
  /// In en, this message translates to:
  /// **'{amount} spent'**
  String budgetSpent(String amount);

  /// No description provided for @budgetOver.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String budgetOver(String amount);

  /// No description provided for @budgetLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String budgetLeft(String amount);

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @noSpendingThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No spending this month yet'**
  String get noSpendingThisMonth;

  /// No description provided for @spendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending Trend'**
  String get spendingTrend;

  /// No description provided for @lastMonths.
  ///
  /// In en, this message translates to:
  /// **'Last {count} months'**
  String lastMonths(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @tapToLogFirst.
  ///
  /// In en, this message translates to:
  /// **'Tap + to log your first one'**
  String get tapToLogFirst;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grocery run'**
  String get descriptionHint;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get enterDescription;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @customCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Custom category name'**
  String get customCategoryName;

  /// No description provided for @customCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Side hustle'**
  String get customCategoryHint;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @fromAccount.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get fromAccount;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get toAccount;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @noAccountsAddFromTab.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet — add one from the Accounts tab.'**
  String get noAccountsAddFromTab;

  /// No description provided for @createAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'Create an account first, then add transactions'**
  String get createAccountFirst;

  /// No description provided for @addSecondAccountTransfer.
  ///
  /// In en, this message translates to:
  /// **'Add a second account to transfer between'**
  String get addSecondAccountTransfer;

  /// No description provided for @chooseTwoDifferentAccounts.
  ///
  /// In en, this message translates to:
  /// **'Choose two different accounts for a transfer'**
  String get chooseTwoDifferentAccounts;

  /// No description provided for @deleteTransactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete transaction?'**
  String get deleteTransactionQuestion;

  /// No description provided for @willBeRemovedPermanently.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be removed permanently.'**
  String willBeRemovedPermanently(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get enterAmount;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @typeUpdated.
  ///
  /// In en, this message translates to:
  /// **'{type} updated'**
  String typeUpdated(String type);

  /// No description provided for @typeAdded.
  ///
  /// In en, this message translates to:
  /// **'{type} added'**
  String typeAdded(String type);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saveTransaction.
  ///
  /// In en, this message translates to:
  /// **'Save transaction'**
  String get saveTransaction;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @saveChangesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get saveChangesQuestion;

  /// No description provided for @addAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add account?'**
  String get addAccountQuestion;

  /// No description provided for @addAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add \"{name}\" to your accounts?'**
  String addAccountConfirm(String name);

  /// No description provided for @saveAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save changes to \"{name}\"?'**
  String saveAccountConfirm(String name);

  /// No description provided for @addTransactionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add transaction?'**
  String get addTransactionQuestion;

  /// No description provided for @addTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add this transaction?'**
  String get addTransactionConfirm;

  /// No description provided for @saveTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save changes to this transaction?'**
  String get saveTransactionConfirm;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @newAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccountTitle;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @accountNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cash, BCA, Visa'**
  String get accountNameHint;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @accountWillBeRemoved.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed. Existing transactions are kept but will no longer be linked to an account.'**
  String accountWillBeRemoved(String name);

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated'**
  String get accountUpdated;

  /// No description provided for @accountAdded.
  ///
  /// In en, this message translates to:
  /// **'Account added'**
  String get accountAdded;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeleted;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @totalAcrossAccounts.
  ///
  /// In en, this message translates to:
  /// **'Total across accounts'**
  String get totalAcrossAccounts;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @noAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccountsYet;

  /// No description provided for @addOneToStart.
  ///
  /// In en, this message translates to:
  /// **'Add one to start tracking balances'**
  String get addOneToStart;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'Opening {amount}'**
  String opening(String amount);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @dynamicColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic color'**
  String get dynamicColor;

  /// No description provided for @dynamicColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use colors from your device wallpaper'**
  String get dynamicColorSubtitle;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @accentDynamicHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a color to switch off dynamic theming'**
  String get accentDynamicHint;

  /// No description provided for @accentPickHint.
  ///
  /// In en, this message translates to:
  /// **'Pick your Material You brand color'**
  String get accentPickHint;

  /// No description provided for @budgetAndCurrency.
  ///
  /// In en, this message translates to:
  /// **'Budget & Currency'**
  String get budgetAndCurrency;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget'**
  String get monthlyBudget;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @appPasscode.
  ///
  /// In en, this message translates to:
  /// **'App passcode'**
  String get appPasscode;

  /// No description provided for @appPasscodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require a 6-digit PIN to open the app'**
  String get appPasscodeSubtitle;

  /// No description provided for @changePasscode.
  ///
  /// In en, this message translates to:
  /// **'Change passcode'**
  String get changePasscode;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock'**
  String get biometricUnlock;

  /// No description provided for @biometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or Face ID'**
  String get biometricSubtitle;

  /// No description provided for @removePasscodeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove passcode?'**
  String get removePasscodeQuestion;

  /// No description provided for @removePasscodeContent.
  ///
  /// In en, this message translates to:
  /// **'The app will no longer be locked. Biometric unlock is also turned off.'**
  String get removePasscodeContent;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @couldNotEnableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Could not enable biometric unlock.'**
  String get couldNotEnableBiometric;

  /// No description provided for @dataAndSync.
  ///
  /// In en, this message translates to:
  /// **'Data & Sync'**
  String get dataAndSync;

  /// No description provided for @exportToCsv.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV'**
  String get exportToCsv;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your transaction history'**
  String get exportSubtitle;

  /// No description provided for @exportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Export is unavailable on this device'**
  String get exportUnavailable;

  /// No description provided for @exportRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Export range'**
  String get exportRangeTitle;

  /// No description provided for @exportAllTime.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get exportAllTime;

  /// No description provided for @exportAllTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export your entire history'**
  String get exportAllTimeSubtitle;

  /// No description provided for @exportCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get exportCustomRange;

  /// No description provided for @exportCustomRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a start and end date'**
  String get exportCustomRangeSubtitle;

  /// No description provided for @importFromCsv.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV'**
  String get importFromCsv;

  /// No description provided for @importSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add transactions from an exported file'**
  String get importSubtitle;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} transactions'**
  String importSuccess(int count);

  /// No description provided for @importEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions found in that file'**
  String get importEmpty;

  /// No description provided for @importUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Import failed. Please pick a valid CSV file'**
  String get importUnavailable;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudSync;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back up to the cloud (demo)'**
  String get cloudSyncSubtitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @enterPasscode.
  ///
  /// In en, this message translates to:
  /// **'Enter passcode'**
  String get enterPasscode;

  /// No description provided for @unlockToContinue.
  ///
  /// In en, this message translates to:
  /// **'Unlock Financely to continue'**
  String get unlockToContinue;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {time}'**
  String tooManyAttempts(String time);

  /// No description provided for @forgotPasscode.
  ///
  /// In en, this message translates to:
  /// **'Forgot passcode?'**
  String get forgotPasscode;

  /// No description provided for @forgotPasscodeContent.
  ///
  /// In en, this message translates to:
  /// **'A local passcode cannot be recovered. To regain access, Financely will remove the passcode and erase all transactions and accounts on this device. This cannot be undone.'**
  String get forgotPasscodeContent;

  /// No description provided for @eraseAndReset.
  ///
  /// In en, this message translates to:
  /// **'Erase & reset'**
  String get eraseAndReset;

  /// No description provided for @passcodeRemovedErased.
  ///
  /// In en, this message translates to:
  /// **'Passcode removed and data erased.'**
  String get passcodeRemovedErased;

  /// No description provided for @setPasscode.
  ///
  /// In en, this message translates to:
  /// **'Set passcode'**
  String get setPasscode;

  /// No description provided for @confirmPasscode.
  ///
  /// In en, this message translates to:
  /// **'Confirm passcode'**
  String get confirmPasscode;

  /// No description provided for @createPasscode.
  ///
  /// In en, this message translates to:
  /// **'Create a passcode'**
  String get createPasscode;

  /// No description provided for @chooseSixDigit.
  ///
  /// In en, this message translates to:
  /// **'Choose a 6-digit passcode'**
  String get chooseSixDigit;

  /// No description provided for @reenterSixDigit.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your 6-digit passcode'**
  String get reenterSixDigit;

  /// No description provided for @pinsDidNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs did not match. Try again.'**
  String get pinsDidNotMatch;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @typeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get typeExpense;

  /// No description provided for @typeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get typeIncome;

  /// No description provided for @typeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get typeTransfer;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get paymentBank;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food & Drink'**
  String get catFood;

  /// No description provided for @catGroceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get catGroceries;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get catHousing;

  /// No description provided for @catTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get catTravel;

  /// No description provided for @catEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get catEducation;

  /// No description provided for @catSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get catSalary;

  /// No description provided for @catInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get catInvestment;

  /// No description provided for @catGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get catGift;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @catTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get catTransfer;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
