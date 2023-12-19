import 'package:cicd/data/repositories/repositories.dart';
import 'package:cicd/locator.dart';
import 'package:cicd/router/routes.dart';
import 'package:cicd/utils/utils.dart';
import 'package:get/get.dart';

class SplashModel extends GetxController {
  var repository = getIt<Repositories>();

  Future<void> refreshToken() async {
    await repository.tokenRefreshApi().then((value) {
      Get.offAllNamed(Routes.dashboard, arguments: [0]);
    }).onError((error, stackTrace) {
      Utils.print(error.toString());
    });
  }
}
