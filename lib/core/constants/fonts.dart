class AppFont {
  /// The font family name as registered in pubspec.yaml.
  final String family;

  /// Human-readable name shown in the picker.
  final String name;

  const AppFont({required this.family, required this.name});
}

const List<AppFont> kAppFonts = <AppFont>[
  AppFont(family: 'Roboto', name: 'Roboto'),
  AppFont(family: 'Poppins', name: 'Poppins'),
  AppFont(family: 'RobotoSlab', name: 'Roboto Slab'),
  AppFont(family: 'ElmsSans', name: 'Elms Sans'),
];

final Map<String, AppFont> kFontByFamily = {
  for (final f in kAppFonts) f.family: f,
};

AppFont fontByFamily(String family) =>
    kFontByFamily[family] ?? kAppFonts.first;
