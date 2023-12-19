import 'package:cicd/screens/auth/forgot_password.dart';
import 'package:cicd/screens/auth/login.dart';
import 'package:cicd/screens/auth/reset_password.dart';
import 'package:cicd/screens/common/pass_detail.dart';
import 'package:cicd/screens/common/profile.dart';
import 'package:cicd/screens/common/dashboard.dart';
import 'package:cicd/screens/common/splash.dart';
import 'package:cicd/screens/common/comments.dart';
import 'package:cicd/screens/student/st_new_request.dart';
import 'package:cicd/screens/student/st_passes_list.dart';
import 'package:cicd/screens/teacher/tr_contact_control.dart';
import 'package:cicd/screens/teacher/tr_contact_control_form.dart';
import 'package:cicd/screens/teacher/tr_limit_student_form.dart';
import 'package:cicd/screens/teacher/tr_limit_students.dart';
import 'package:cicd/screens/teacher/tr_location_limit.dart';
import 'package:cicd/screens/teacher/tr_location_limits_list.dart';
import 'package:cicd/screens/teacher/tr_notification_settings.dart';
import 'package:cicd/screens/common/notifications_alerts.dart';
import 'package:cicd/screens/teacher/tr_out_of_office.dart';
import 'package:cicd/screens/teacher/tr_out_of_office_list.dart';
import 'package:cicd/screens/teacher/tr_passes.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/splash';
  static String login = '/login';
  static String forgotPassword = '/forgot_password';
  static String resetPassword = '/reset_password';
  static String dashboard = '/st_dashboard';
  static String profile = '/st_profile';
  static String stNewRequest = '/st_new_request';
  static String stPassesList = '/st_passes_list';
  static String passDetail = '/st_pass_detail';
  static String trPasses = '/tr_passes';
  static String comments = '/tr_comments';
  static String trLocationLimit = '/tr_location_limit';
  static String trOutOfOffice = '/tr_out_off_office';
  static String trOutOfOfficeList = '/tr_out_off_office_list';
  static String trNotifications = '/tr_notifications';
  static String trLimitStudent = '/tr_limit_student';
  static String trNotificationSettings = '/tr_notification_settings';
  static String trLimitStudentForm = '/tr_limit_student_form';
  static String trContactControl = '/tr_contact_control';
  static String trContactControlForm = '/tr_contact_control_form';
  static String trLocationLimitList = '/tr_location_limit_list';
}

/// Add this list variable into your GetMaterialApp as the value of getPages parameter.
/// You can get the reference to the above GetMaterialApp code.

var transitionAnimation = Transition.rightToLeftWithFade;
final getPages = [
  GetPage(
    name: Routes.splash,
    page: () => const Splash(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.login,
    page: () => const Login(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.dashboard,
    page: () => const Dashboard(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.stNewRequest,
    page: () => const StNewRequest(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.profile,
    page: () => const Profile(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.forgotPassword,
    page: () => const ForgotPassword(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => const ResetPassword(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.stPassesList,
    page: () => const StPassesList(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.passDetail,
    page: () => const PassDetail(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.comments,
    page: () => const Comments(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trPasses,
    page: () => const TrPasses(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trLocationLimitList,
    page: () => const TrLocationLimitList(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trLocationLimit,
    page: () => const TrLocationLimit(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trNotifications,
    page: () => const NotificationsAlerts(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trLimitStudent,
    page: () => const TrLimitStudents(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trNotificationSettings,
    page: () => const TrNotificationSettings(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trLimitStudentForm,
    page: () => const TrLimitStudentForm(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trOutOfOfficeList,
    page: () => const TrOutOfOfficeList(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trOutOfOffice,
    page: () => const TrOutOfOffice(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trContactControl,
    page: () => const TrContactControl(),
    transition: transitionAnimation,
  ),
  GetPage(
    name: Routes.trContactControlForm,
    page: () => const TrContactControlForm(),
    transition: transitionAnimation,
  ),
];
