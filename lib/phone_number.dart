import 'countries.dart';

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class InvalidCountryException implements Exception {}

class PhoneNumber {
  String countryISOCode;
  String countryCode;
  String number;
  Country get country => countries.singleWhere(
        (Country country) => country.code == countryISOCode,
        orElse: () => getCountry(number),
      );

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
  });

  factory PhoneNumber.fromCompleteNumber({required String completeNumber}) {
    if (completeNumber == "") {
      return PhoneNumber(countryISOCode: "", countryCode: "", number: "");
    }

    try {
      Country country = getCountry(completeNumber);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber
            .substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber
            .substring(country.dialCode.length + country.regionCode.length);
      }
      return PhoneNumber(
          countryISOCode: country.code,
          countryCode: country.dialCode + country.regionCode,
          number: number)
        ..checkNumber();
    } catch (e) {
      if (e is NumberTooShortException ||
          e is NumberTooLongException ||
          e is InvalidCharactersException) {
        rethrow;
      } else {
        return PhoneNumber(countryISOCode: "", countryCode: "", number: "");
      }
    }
  }

  void checkNumber() {
    if (!RegExp(r'^[+0-9]*[0-9]*$').hasMatch(number)) {
      throw InvalidCharactersException();
    }
    if (number.length < country.minLength) {
      throw NumberTooShortException();
    }

    if (number.length > country.maxLength) {
      throw NumberTooLongException();
    }
  }

  bool isValidNumber() {
    try {
      checkNumber();
    } catch (e) {
      if (e is NumberTooShortException ||
          e is NumberTooLongException ||
          e is InvalidCharactersException) {
        return false;
      } else {
        rethrow;
      }
    }
    return true;
  }

  String get completeNumber {
    return countryCode + number;
  }

  static Country getCountry(String phoneNumber) {
    if (phoneNumber == "") {
      throw NumberTooShortException();
    }

    if (phoneNumber.startsWith('+')) {
      return countries.firstWhere((country) => phoneNumber
          .substring(1)
          .startsWith(country.dialCode + country.regionCode));
    }
    return countries.firstWhere((country) =>
        phoneNumber.startsWith(country.dialCode + country.regionCode));
  }

  String toString() =>
      'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';
}
