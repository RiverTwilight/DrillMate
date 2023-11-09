import 'dart:io';

import 'package:hgeology_app/services/media_controller.dart';
import 'package:http/http.dart' as http;

MediaType? checkResource(String url) {
  if (url.contains('youtube')) {
    return MediaType.youtube;
  } else if (url.contains('bilibili') || url.contains('b23.tv')) {
    return MediaType.bilibili;
  }
  return null;
}

Future<String> getRealUrl(String shortUrl) async {
  if (shortUrl.contains('www.bilibili.com')) {
    return shortUrl;
  }

  var response = await http.post(
    Uri.parse(shortUrl),
    headers: {
      "Accept": 'application/json',
      "User-Agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
              "(KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36",
    },
  );
  // with below code you get the full path of a short url
  String fullPath = response.headers.entries
      .firstWhere((element) => element.key == "location")
      .value;

  return fullPath;
}
