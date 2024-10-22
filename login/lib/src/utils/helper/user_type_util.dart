class UserTypeUtil {
  static UserType identifyUserType(Map<String, dynamic> userData) {
    if (userData.containsKey('cnic')) {
      return UserType.farmer;
    } else {
      return UserType.user;
    }
  }
}

enum UserType {
  user,
  farmer,
}
