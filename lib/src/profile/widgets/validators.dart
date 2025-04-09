String? validateName(String? value) {
  // Check if the value is null or empty
  // and return an error message if it is
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? validateEmail(String? value) {
  // Regular expression to check if the email ends with "@gmail.com"
  // and contains only valid characters before it
  final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  if (value == null || value.isEmpty || !emailRegExp.hasMatch(value)) {
    return 'Email must end with "@gmail.com"';
  }
  return null;
}

String? validatePhone(String? value) {
  // Regular expression to check if the phone number starts with "01"
  // and is followed by 8 digits
  final RegExp phoneRegExp = RegExp(r'^01\d{8}$');
  if (value == null || value.isEmpty || !phoneRegExp.hasMatch(value)) {
    return 'Phone number must start with "01" and be followed by 8 digits';
  }
  return null;
}