import 'package:cicd/constants/session_keys.dart';
import 'package:cicd/models/common_models/value_text_model.dart';

abstract class ApiFilters {
  static ValueTextModel districtData =
      ValueTextModel(text: '', value: 0, selected: false, search: false);
  static ValueTextModel schoolData =
      ValueTextModel(text: '', value: 0, selected: false, search: false);

  static String schoolId = '';
  static int districtId = 0;
  static int userId = 0;

  static void setUserId(value) {
    if (value != null) {
      userId = value;
    } else {
      userId = 0;
    }
  }

  static void setSchoolId(String value) {
    if (value != '' && value != 'null') {
      schoolId = value;
    } else {
      schoolId = '';
    }
  }

  static void setDistrictId(value) {
    if (value != null) {
      districtId = value;
    } else {
      districtId = 0;
    }
  }

  static int getDistrictId() {
    return ApiFilters.districtId;
  }

  static String getStudentFilter() {
    String value = '';
    if (userId == 0) {
      value = '';
    } else {
      value = '?studentId=$userId';
    }
    return value;
  }

  static String getSchoolFilter() {
    String value = '';
    if (schoolId == '') {
      value = '';
    } else {
      value = '?schoolIdArr=$schoolId';
    }
    return value;
  }

  static String getDistrictFilter() {
    String value = '';
    if (districtId == 0) {
      value = '';
    } else {
      value = '?districtId=$districtId';
    }
    return value;
  }

  static String getTeacherFilter() {
    String value = '';
    if (UserType.isTeacher()) {
      if (userId == 0) {
        value = '';
      } else {
        value = '?teacherId=$userId';
      }
    }
    return value;
  }

  static String getSchoolDistrictFilter() {
    String value = '';
    if (schoolId == '' && districtId == 0) {
      value = '';
    } else if (schoolId == '') {
      value = '?districtId=$districtId';
    } else if (districtId == 0) {
      value = '?schoolIdArr=$schoolId';
    } else {
      value = '?districtId=$districtId&schoolIdArr=$schoolId';
    }
    return value;
  }

  static String getSchoolDistrictUserFilter() {
    String value = '';
    if (schoolId == '' && districtId == 0) {
      value = '';
    } else if (schoolId == '') {
      value = '?districtId=$districtId';
    } else if (districtId == 0) {
      value = '?schoolId=${schoolId.split(',')[0]}';
    } else {
      value = '?districtId=$districtId&schoolId=${schoolId.split(',')[0]}';
    }
    return '$value${appendUserID(value)}';
  }

  static String getUserFilter() {
    String value = '';

    if (userId != 0) {
      value = '?userId=$userId';
    }

    return value;
  }

  static String getEPassListFilter() {
    String value = '';
    if (UserType.isTeacher()) {
      if (userId != 0) {
        value = '?teacherId=$userId';
      }
    } else if (UserType.isStudent()) {
      if (userId != 0) {
        value = '?studentId=$userId';
      }
    } else {
      if (schoolId != '') {
        value = '?schoolIdArr=$schoolId';
      }
    }
    return value;
  }

  static String appendUserID(String value) {
    return value.trim() == '' ? '?userId=$userId' : '&userId=$userId';
  }
}
