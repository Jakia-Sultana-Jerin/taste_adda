import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


// final baseUrl = kIsWeb ? 'https://dingo-proper-mistakenly.ngrok-free.app/' : 'https://dingo-proper-mistakenly.ngrok-free.app/';

Future<void> sendNotification({
  required String title,
  required String body,
  required String url,
}) async {
  const String appId = "e34d9844-204c-4a8a-a8ef-7e064f326d73";
  const String restApiKey = "os_v2_app_4ngzqrbajrfivkhppyde6mtnopoaed5v2a4eylen66espdth3otnj3z2mv4dyq65vyvctfag3tt5ug63kx3upok5lrcojqekdtsylpy";
  final Dio dio = Dio();
  try {
    final response = await dio.post(
      "https://onesignal.com/api/v1/notifications",
      options: Options(
        headers: {
          "Authorization": "Basic $restApiKey",
          "Content-Type": "application/json",
        },
      ),
      data: {
        "app_id": appId,
        "included_segments": ["All"],
        "headings": {"en": title},
        "contents": {"en": body},
        "url": url,
      },
    );

    print("✅ Notification Sent: ${response.data}");

    // Notification sent successfully
  } catch (e) {
    print("❌ Error sending notification: $e");
  }
}


