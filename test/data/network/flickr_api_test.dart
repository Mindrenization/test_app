import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test_app/data/network/flickr_api.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('fetchPhotos', () {
    const flickrImage = {
      "id": "",
      "secret": "",
      "server": "",
      "farm": 1,
      "title": "",
    };

    const flickrImages = {
      "pages": 1,
      "photo": [flickrImage],
    };

    const flickrResponse = {
      "photos": flickrImages,
      "stat": "ok",
    };

    http.Client httpClient;
    FlickrApi flickrApi;

    setUp(() {
      httpClient = MockClient();
      flickrApi = FlickrApi();
    });

    test('Получение списка изображений ', () async {
      when(httpClient.get(any)).thenAnswer((_) async => http.Response(
            jsonEncode(flickrResponse),
            HttpStatus.ok,
          ));
      final encodeResponse = await flickrApi.fetchImages();
      expect(encodeResponse.imageList != null, true);
    });
  });
}
