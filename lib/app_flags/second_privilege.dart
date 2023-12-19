// ignore_for_file: constant_identifier_names

import 'package:enum_flag/enum_flag.dart';

enum PrivilegeSecond with EnumFlag {
  EPassTodayHistory,
  StudentsGetAll,
  LocationAdd,
  LocationEdit,
  LocationExport,
  LocationGetById,
  LocationImageUpload,
  LocationList,
  LocationStatus,
  LocationImport,
  LocationLimitAdd,
  LocationLimitEdit,
  LocationLimitGetById,
  LocationLimitList,
  LocationLimitStatus,
  NotificationByEPassId,
  NotificationGetById,
  NotificationSettingGet,
  NotificationSettingUpdate,
  OutOfOfficeAdd,
  OutOfOfficeEdit,
  OutOfOfficeGetById,
  OutOfOfficeList,
  OutOfOfficeResume,
  OutOfOfficeStatus,
  PermissionGroupAdd,
  PermissionGroupEdit,
  PermissionGroupGetById,
  PermissionGroupList,
  PermissionGroupStatus,
  ProfileUpdate,
}

abstract class PrivilegeSecondFlags {
  static int secondPrivilege = 0;
}
