class Apis {
  static String baseUrl = 'https://epass.trajectus.com';
  static String refreshToken = '$baseUrl/api/v1/Users/RefreshToken';
  static String signUp = '$baseUrl/Users/SignUp';
  static String logIn = '$baseUrl/api/v1/Auth/SignIn';
  static String postFcmToken = '$baseUrl/api/v1/Users/SaveRegistrationToken';
  static String otpRequest = '$baseUrl/api/v1/Otp/Request';
  static String otpVerify = '$baseUrl/api/v1/Otp/Verify';
  static String forgotPasswordOtpRequest =
      '$baseUrl/api/v1/Auth/ForgotPassword';
  static String resetPassword = '$baseUrl/api/v1/Auth/ChangePassword';
  static String dropDownLimit = '$baseUrl/api/v1/DropDownList/Limit';
  static String locationLimits = '$baseUrl/api/v1/LocationLimit';
  static String getLocations = '$baseUrl/api/v1/Location/Select';
  static String getOnlyLocations = '$baseUrl/api/v1/Location';
  static String getEPassStatus = '$baseUrl/api/v1/EPass/Select';
  static String locationLimitById = '$locationLimits/Id';
  static String contactControl = '$baseUrl/api/v1/ContactControl';
  static String contactControlById = '$contactControl/Id';
  static String getStudentsDropListData = '$baseUrl/api/v1/Student/Select';
  static String getPresetsDropListData = '$baseUrl/api/v1/Presets/Select';
  static String getTimeData = '$baseUrl/api/v1/Time/Select';
  static String getRepetitionDropListData = '$baseUrl/api/v1/Repetition/Select';
  static String studentLimitPasses = '$baseUrl/api/v1/StudentLimit';
  static String getStudentLimitPassesById = '$studentLimitPasses/Id';
  static String getTeacherLocationsDropDown =
      '$baseUrl/api/v1/TeacherLocation/Select';
  static String getStudentEPassLimit =
      '$baseUrl/api/v1/EPass/StudentEpassLimit';
  static String getTeacherDropDown = '$baseUrl/api/v1/Teacher/Select';
  static String addNewPass = '$baseUrl/api/v1/EPass/Issue';
  static String requestNewPass = '$baseUrl/api/v1/EPass/Request';
  static String getAllPasses = '$baseUrl/api/v1/EPass';
  static String getStAllPasses = '$baseUrl/api/v1/EPass/TodayHistory';
  static String getPassById = '$baseUrl/api/v1/EPass/Id';
  static String outOfOffice = '$baseUrl/api/v1/OutOfOffice';
  static String outOfOfficeById = '$baseUrl/api/v1/OutOfOffice/Id';
  static String getNotifications = '$baseUrl/api/v1/Notification/UserId';
  static String getAlerts = '$baseUrl/api/v1/Notification/EpassId';
  static String getNotificationSettings =
      '$baseUrl/api/v1/NotificationSetting/Get';
  static String postComment = '$baseUrl/api/v1/EPass/Comment';
  static String postApproval = '$baseUrl/api/v1/EPass/Approved';
  static String postDeparted = '$baseUrl/api/v1/EPass/Departed';
  static String postRejection = '$baseUrl/api/v1/EPass/Rejected';
  static String postEnd = '$baseUrl/api/v1/EPass/Completed';
  static String postReceived = '$baseUrl/api/v1/EPass/Received';
  static String postNotificationSettings =
      '$baseUrl/api/v1/NotificationSetting/Update';
  static String getPassComments = '$baseUrl/api/v1/EPass/CommentList';
  static String postResume = '$baseUrl/api/v1/OutOfOffice/Resume';

  static String getProfile = '$baseUrl/api/v1/Users/Id';
  static String updateProfile = '$baseUrl/api/v1/Users/Profile';
  static String updateProfileImage = '$baseUrl/api/v1/Users/ImageUpload';
  static String getLogout = '$baseUrl/api/v1/Users/LogOut';
  static String getLimits = '$baseUrl/api/v1/Limit/Select';
  static String getDistricts = '$baseUrl/api/v1/District';
  static String getSchools = '$baseUrl/api/v1/Schools';
  static String getDashboardData = '$baseUrl/api/v1/DashBoard/Admin';
}
