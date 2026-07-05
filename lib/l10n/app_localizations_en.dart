// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Financely';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get balanceTotalBalance => 'Total Balance';

  @override
  String get balanceIncome => 'Income';

  @override
  String get balanceSpent => 'Spent';

  @override
  String get budgetMonthlyBudget => 'Monthly Budget';

  @override
  String budgetSpent(String amount) {
    return '$amount spent';
  }

  @override
  String budgetOver(String amount) {
    return '$amount over';
  }

  @override
  String budgetLeft(String amount) {
    return '$amount left';
  }

  @override
  String get topCategories => 'Top Categories';

  @override
  String get thisMonth => 'This month';

  @override
  String get noSpendingThisMonth => 'No spending this month yet';

  @override
  String get spendingTrend => 'Spending Trend';

  @override
  String lastMonths(int count) {
    return 'Last $count months';
  }

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get seeAll => 'See all';

  @override
  String get noActivityYet => 'No activity yet';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get tapToLogFirst => 'Tap + to log your first one';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get delete => 'Delete';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'e.g. Grocery run';

  @override
  String get enterDescription => 'Enter a description';

  @override
  String get category => 'Category';

  @override
  String get customCategoryName => 'Custom category name';

  @override
  String get customCategoryHint => 'e.g. Side hustle';

  @override
  String get date => 'Date';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get fromAccount => 'From account';

  @override
  String get account => 'Account';

  @override
  String get toAccount => 'To account';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get noAccountsAddFromTab =>
      'No accounts yet — add one from the Accounts tab.';

  @override
  String get createAccountFirst =>
      'Create an account first, then add transactions';

  @override
  String get addSecondAccountTransfer =>
      'Add a second account to transfer between';

  @override
  String get chooseTwoDifferentAccounts =>
      'Choose two different accounts for a transfer';

  @override
  String get deleteTransactionQuestion => 'Delete transaction?';

  @override
  String willBeRemovedPermanently(String title) {
    return '\"$title\" will be removed permanently.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get undo => 'Undo';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get enterAmount => 'Enter an amount';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String typeUpdated(String type) {
    return '$type updated';
  }

  @override
  String typeAdded(String type) {
    return '$type added';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveTransaction => 'Save transaction';

  @override
  String get confirm => 'Confirm';

  @override
  String get saveChangesQuestion => 'Save changes?';

  @override
  String get addAccountQuestion => 'Add account?';

  @override
  String addAccountConfirm(String name) {
    return 'Add \"$name\" to your accounts?';
  }

  @override
  String saveAccountConfirm(String name) {
    return 'Save changes to \"$name\"?';
  }

  @override
  String get addTransactionQuestion => 'Add transaction?';

  @override
  String get addTransactionConfirm => 'Add this transaction?';

  @override
  String get saveTransactionConfirm => 'Save changes to this transaction?';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get newAccountTitle => 'New Account';

  @override
  String get accountName => 'Account name';

  @override
  String get accountNameHint => 'e.g. Cash, BCA, Visa';

  @override
  String get enterName => 'Enter a name';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get deleteAccountQuestion => 'Delete account?';

  @override
  String accountWillBeRemoved(String name) {
    return '\"$name\" will be removed. Existing transactions are kept but will no longer be linked to an account.';
  }

  @override
  String get accountUpdated => 'Account updated';

  @override
  String get accountAdded => 'Account added';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String get createAccount => 'Create account';

  @override
  String get totalAcrossAccounts => 'Total across accounts';

  @override
  String get newAccount => 'New account';

  @override
  String get noAccountsYet => 'No accounts yet';

  @override
  String get addOneToStart => 'Add one to start tracking balances';

  @override
  String opening(String amount) {
    return 'Opening $amount';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get dynamicColor => 'Dynamic color';

  @override
  String get dynamicColorSubtitle => 'Use colors from your device wallpaper';

  @override
  String get font => 'Font';

  @override
  String get accentColor => 'Accent color';

  @override
  String get accentDynamicHint => 'Pick a color to switch off dynamic theming';

  @override
  String get accentPickHint => 'Pick your Material You brand color';

  @override
  String get budgetAndCurrency => 'Budget & Currency';

  @override
  String get monthlyBudget => 'Monthly budget';

  @override
  String get amount => 'Amount';

  @override
  String get save => 'Save';

  @override
  String get currency => 'Currency';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get security => 'Security';

  @override
  String get appPasscode => 'App passcode';

  @override
  String get appPasscodeSubtitle => 'Require a 6-digit PIN to open the app';

  @override
  String get changePasscode => 'Change passcode';

  @override
  String get biometricUnlock => 'Biometric unlock';

  @override
  String get biometricSubtitle => 'Use fingerprint or Face ID';

  @override
  String get removePasscodeQuestion => 'Remove passcode?';

  @override
  String get removePasscodeContent =>
      'The app will no longer be locked. Biometric unlock is also turned off.';

  @override
  String get remove => 'Remove';

  @override
  String get couldNotEnableBiometric => 'Could not enable biometric unlock.';

  @override
  String get dataAndSync => 'Data & Sync';

  @override
  String get exportToCsv => 'Export to CSV';

  @override
  String get exportSubtitle => 'Share your transaction history';

  @override
  String get exportUnavailable => 'Export is unavailable on this device';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get cloudSyncSubtitle => 'Back up to the cloud (demo)';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get enterPasscode => 'Enter passcode';

  @override
  String get unlockToContinue => 'Unlock Financely to continue';

  @override
  String tooManyAttempts(String time) {
    return 'Too many attempts. Try again in $time';
  }

  @override
  String get forgotPasscode => 'Forgot passcode?';

  @override
  String get forgotPasscodeContent =>
      'A local passcode cannot be recovered. To regain access, Financely will remove the passcode and erase all transactions and accounts on this device. This cannot be undone.';

  @override
  String get eraseAndReset => 'Erase & reset';

  @override
  String get passcodeRemovedErased => 'Passcode removed and data erased.';

  @override
  String get setPasscode => 'Set passcode';

  @override
  String get confirmPasscode => 'Confirm passcode';

  @override
  String get createPasscode => 'Create a passcode';

  @override
  String get chooseSixDigit => 'Choose a 6-digit passcode';

  @override
  String get reenterSixDigit => 'Re-enter your 6-digit passcode';

  @override
  String get pinsDidNotMatch => 'PINs did not match. Try again.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get typeExpense => 'Expense';

  @override
  String get typeIncome => 'Income';

  @override
  String get typeTransfer => 'Transfer';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentBank => 'Bank';

  @override
  String get catFood => 'Food & Drink';

  @override
  String get catGroceries => 'Groceries';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catBills => 'Bills';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catHealth => 'Health';

  @override
  String get catHousing => 'Housing';

  @override
  String get catTravel => 'Travel';

  @override
  String get catEducation => 'Education';

  @override
  String get catSalary => 'Salary';

  @override
  String get catInvestment => 'Investment';

  @override
  String get catGift => 'Gift';

  @override
  String get catOther => 'Other';

  @override
  String get catTransfer => 'Transfer';
}
