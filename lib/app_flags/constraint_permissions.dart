// ignore_for_file: constant_identifier_names

import 'package:cicd/constants/session_keys.dart';
import 'package:enum_flag/enum_flag.dart';

enum ConstraintPermissions with EnumFlag {
  CreateLocationLimit, //1
  OverrideLocationLimit, //2
  CreateOutOfOffice,
  OverrideSOutOfOffice, //8
  CreateStudentPassesLimit, //
  OverrideStudentPassesLimit,
  CanCreateContactControl,
  CanOverrideContactControl,
  Notifications,
  All,
}

abstract class ConstraintFlags {
  static int permissions = 0;

  static bool canCreateLocationLimit() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.CreateLocationLimit);
  }

  static bool canOverrideLocationLimit() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.OverrideLocationLimit);
  }

  static bool canCreateOutOfOffice() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.CreateOutOfOffice);
  }

  static bool canOverrideSOutOfOffice() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.OverrideSOutOfOffice);
  }

  static bool canCreateStudentPassesLimit() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.CreateStudentPassesLimit);
  }

  static bool canOverrideStudentPassesLimit() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.OverrideStudentPassesLimit);
  }

  static bool canCanCreateContactControl() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.CanCreateContactControl);
  }

  static bool canCanOverrideContactControl() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.CanOverrideContactControl);
  }

  static bool canNotifications() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.Notifications);
  }

  static bool canAll() {
    return UserType.isAdmin()
        ? true
        : permissions
            .getFlags(ConstraintPermissions.values)
            .contains(ConstraintPermissions.All);
  }
}
