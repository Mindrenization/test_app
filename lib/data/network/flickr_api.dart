import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test_app/data/models/image.dart';

class FlickrApi {
  fetchImages({String search = 'cat', int page = 1}) async {
    List<String> _imageList = [];
    String url =
        'https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=56fdcf850a8905f4ed8842157b666749&tags=$search&per_page=20&page=$page&format=json&nojsoncallback=1';
    try {
      final response = await http.get(url);
      final parsed = await jsonDecode(response.body);
      if (parsed["stat"] == 'ok') {
        List<Image> images = parsed["photos"]["photo"]
            .map<Image>((json) => Image.fromJson(json))
            .toList();
        for (int i = 0; i < images.length; i++) {
          String url =
              'https://farm${images[i].farm}.staticflickr.com/${images[i].server}/${images[i].id}_${images[i].secret}.jpg';
          _imageList.add(url);
        }
        return _imageList;
      }
    } on SocketException catch (_) {
      return 'error';
    } catch (_) {
      return 'error';
    }
  }
}
