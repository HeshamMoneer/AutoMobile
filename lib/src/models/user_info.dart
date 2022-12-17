class UserInfo {
  String firstName;
  String lastName;
  String email;
  String password;
  DateTime birthDate;
  double balance;
  String phoneNumber;
  String profilePicPath;
  bool isMale;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.birthDate,
    required this.balance,
    required this.phoneNumber,
    required this.profilePicPath,
    required this.isMale,
  });
}
