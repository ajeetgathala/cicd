abstract class SessionKeys {
  static int typeId = 0;
  static bool inForeground = true;

  static String ePassTime = '';
}

abstract class UserType {
  static int student = 5;
  static int teacher = 4;
  static int schoolOperator = 3;
  static int districtAdmin = 2;
  static int admin = 1;

  static void setUserType(key) {
    if (key == student) {
      SessionKeys.typeId = student;
    } else if (key == teacher) {
      SessionKeys.typeId = teacher;
    } else if (key == schoolOperator) {
      SessionKeys.typeId = schoolOperator;
    } else if (key == districtAdmin) {
      SessionKeys.typeId = districtAdmin;
    } else {
      SessionKeys.typeId = admin;
    }
  }

  static bool isStudent() {
    return SessionKeys.typeId == student;
  }

  static bool isTeacher() {
    return SessionKeys.typeId == teacher;
  }

  static bool isSchoolOperator() {
    return SessionKeys.typeId == schoolOperator;
  }

  static bool isDistrictAdmin() {
    return SessionKeys.typeId == districtAdmin;
  }

  static bool isAdmin() {
    return SessionKeys.typeId == admin;
  }
}
