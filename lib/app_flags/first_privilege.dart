// ignore_for_file: constant_identifier_names

import 'package:cicd/constants/session_keys.dart';
import 'package:enum_flag/enum_flag.dart';

enum PrivilegeFirst with EnumFlag {
  AuditTrailExport,
  AuditTrailGetById,
  ContactControlAdd,
  ContactControlEdit,
  ContactControlGetById,
  ContactControlList,
  ContactControlStatus,
  DashBoardAdmin,
  DashBoardStudent,
  DistrictAdd,
  DistrictEdit,
  DistrictExport,
  DistrictGetById,
  DistrictImport,
  DistrictList,
  DistrictStatus,
  EPassApproved,
  EPassById,
  EPassChangeJourneyTimeSave,
  EPassComment, //-
  EPassCommentList, //-
  EPassCompleted, //-
  EPassDeparted,
  EPassExport,
  EPassHistory,
  EPassIssue, //-
  EPassList,
  EPassReceived,
  EPassRejected,
  EPassRequest, //-
  EPassStudentList
}

abstract class PrivilegeFirstFlags {
  static int privilegeFirst = 0;

  static bool canCreateEPassComment() {
    return UserType.isAdmin()
        ? true
        : privilegeFirst
            .getFlags(PrivilegeFirst.values)
            .contains(PrivilegeFirst.EPassComment);
  }

  static bool canViewEPassCommentList() {
    return UserType.isAdmin()
        ? true
        : privilegeFirst
            .getFlags(PrivilegeFirst.values)
            .contains(PrivilegeFirst.EPassCommentList);
  }

  static bool canEPassComplete() {
    return UserType.isAdmin()
        ? true
        : privilegeFirst
            .getFlags(PrivilegeFirst.values)
            .contains(PrivilegeFirst.EPassCompleted);
  }

  static bool canEPassIssue() {
    return UserType.isAdmin()
        ? true
        : privilegeFirst
            .getFlags(PrivilegeFirst.values)
            .contains(PrivilegeFirst.EPassIssue);
  }

  static bool canEPassRequest() {
    return UserType.isAdmin()
        ? true
        : privilegeFirst
            .getFlags(PrivilegeFirst.values)
            .contains(PrivilegeFirst.EPassRequest);
  }
}
