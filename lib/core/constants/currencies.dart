class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({required this.code, required this.symbol, required this.name});
}

const List<Currency> kSupportedCurrencies = <Currency>[
  Currency(code: 'USD', symbol: r'$', name: 'US Dollar'),
  Currency(code: 'EUR', symbol: '€', name: 'Euro'),
  Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
  Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
  Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  Currency(code: 'AUD', symbol: r'A$', name: 'Australian Dollar'),
  Currency(code: 'SGD', symbol: r'S$', name: 'Singapore Dollar'),
];

final Map<String, Currency> kCurrencyByCode = {
  for (final c in kSupportedCurrencies) c.code: c,
};

Currency currencyByCode(String code) =>
    kCurrencyByCode[code] ?? kSupportedCurrencies.first;
