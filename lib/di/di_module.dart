import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class InjectorModule {
  @lazySingleton
  Dio get dio => Dio();
}
