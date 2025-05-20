import 'package:dio/dio.dart';

class HomeViewModel {
  final dio = Dio();

  Future<void> fetchHome() async {
    try {
      final response = await dio.get(
        "https://api.npoint.io/416d7e3a1b58126c480f",
      );

      print(response);
    } catch (e) {}
  }
}
