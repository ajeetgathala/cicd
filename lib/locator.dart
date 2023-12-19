import 'package:cicd/utils/utils.dart';
import 'package:get_it/get_it.dart';

import 'data/repositories/repositories.dart';

GetIt getIt = GetIt.instance;

void locator() {
  if (!getIt.isRegistered<Repositories>()) {
    getIt.registerLazySingleton<Repositories>(() => Repositories());
  }
  if (!getIt.isRegistered<Utils>()) {
    getIt.registerLazySingleton<Utils>(() => Utils());
  }
}
