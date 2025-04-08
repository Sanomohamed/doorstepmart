String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? validateEmail(String? value) {
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  if (value == null || value.isEmpty || !emailRegExp.hasMatch(value)) {
    return 'Email must end with "@gmail.com"';
  }
  return null;
}

String? validatePhone(String? value) {
  final RegExp phoneRegExp = RegExp(r'^01\d{8}$');
  if (value == null || value.isEmpty || !phoneRegExp.hasMatch(value)) {
    return 'Phone number must start with "01" and be followed by 8 digits';
  }
  return null;
}