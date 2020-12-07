import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/data/models/raw_image.dart';

class FlickrApi {
  fetchImages({String search = 'waterfall', int page = 1}) async {
    List<String> _imageList = [];
    String url =
        'https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=4882500c1ee0b53c82567d45d2f55f29&tags=$search&per_page=20&page=$page&format=json&nojsoncallback=1';
    try {
      final response = await http.get(url);
      final parsed = await jsonDecode(response.body);
      if (parsed["stat"] == 'ok') {
        List<RawImage> images = parsed["photos"]["photo"]
            .map<RawImage>((json) => RawImage.fromJson(json))
            .toList();
        for (int i = 0; i < images.length; i++) {
          String url =
              'https://farm${images[i].farm == 0 ? 66 : images[i].farm}.staticflickr.com/${images[i].server}/${images[i].id}_${images[i].secret}.jpg';
          _imageList.add(url);
        }
        return _imageList;
      } else {
        return 'error';
      }
    } catch (_) {
      return 'error';
    }
  }
}
