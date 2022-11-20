import 'package:intl_phone_field/countries.dart';

bool isNumeric(String s) =>
    s.isNotEmpty && num.tryParse(s.replaceAll("+", "")) != null;

extension CountryExtensions on List<Country> {
  List<Country> stringSearch(String search, {String? locale}) {
    search = search.trim();
    return search == '+' || search == ''
        ? this
        : isNumeric(search)
            ? (where((country) =>
                    country.dialCode.startsWith(search.replaceAll("+", "")))
                .toList()
              ..sort(((a, b) => a.dialCode.compareTo(b.dialCode))))
            : where(
                (country) =>
                    ((locale != null &&
                            country.nameTranslations.containsKey(locale))
                        ? country.nameTranslations[locale]!
                            .toLowerCase()
                            .startsWith(search)
                        : country.nameTranslations.values
                            .map((String nameTranslation) =>
                                nameTranslation.toLowerCase())
                            .any((element) => element.startsWith(search))) ||
                    country.name.toLowerCase().startsWith(search.toLowerCase()),
              ).toList();
  }
}
