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

