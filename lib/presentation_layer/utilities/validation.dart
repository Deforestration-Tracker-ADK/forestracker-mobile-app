import 'package:html/parser.dart';

String validatePassword(value) {
  RegExp pwReg = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
  );
  value = value.toString();
  if (value.isEmpty) {
    return "* Required";
  } else if (value.length < 6) {
    return "Password should be at least 6 characters";
  } else if (!pwReg.hasMatch(value)) {
    return "Password must follow the given constraints.";
  }
  return null;
}

String validateUsername(value) {
  RegExp nameReg = RegExp(
    r'[A-Z]',
    caseSensitive: false,
  );
  value = value.toString().trim();
  if (value.isEmpty) {
    return "* Required";
  } else if (value.length < 6) {
    return "Username should be at least 6 characters";
  }else if (!nameReg.hasMatch(value)) {
    return "First name should only contain letters";
  }
  return null;
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

