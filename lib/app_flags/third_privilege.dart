// ignore_for_file: constant_identifier_names

import 'package:enum_flag/enum_flag.dart';

enum PrivilegeThird with EnumFlag {
  ReportExport,
  ReportSearchList,
  ReportStudentList,
  SchoolAdd,
  SchoolEdit,
  SchoolExport,
  SchoolGetById,
  SchoolImport,
  SchoolList,
  SchoolStatus,
  StudentEPassLimitGet,
  StudentLimitAdd,
  StudentLimitEdit,
  StudentLimitGetById,
  StudentLimitList,
  StudentLimitStatus,
  UserAdd,
  UserEdit,
  UserExport,
  UserGetById,
  UserImageUpload,
  UserImport,
  UserList,
  UserStatus,
}

abstract class PrivilegeThirdFlags {
  static int privilegeThird = 0;
}
