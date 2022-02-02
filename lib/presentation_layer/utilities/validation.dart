import 'package:html/parser.dart';

String validatePassword(value) {
  value = value.toString();
  if (value.isEmpty) {
    return "* Required";
  } else if (value.length < 6) {
    return "Password should be at least 6 characters";
  }
  return null;
}

String validateUsername(value) {
  value = value.toString();
  if (value.isEmpty) {
    return "* Required";
  } else if (value.length < 6) {
    return "Username should be at least 6 characters";
  }
  return null;
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}

