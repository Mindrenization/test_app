import 'dart:io';

import 'package:test_app/data/models/flickr_response.dart';
import 'package:test_app/data/network/flickr_api.dart';

class FlickrApiWrapper {
  Future<FlickrResponse> fetchImages({String search = 'waterfall', int page = 1}) async {
    try {
      return await FlickrApi().fetchImages(search: search, page: page);
    } on SocketException {
      return FlickrResponse(error: 'network error');
    } catch (e) {
      return FlickrResponse(error: 'error');
    }
  }
}
