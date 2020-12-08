import 'package:test_app/data/network/flickr_api.dart';

class FlickrApiWrapper {
  fetchImages({String search = 'waterfall', int page = 1}) async {
    try {
      return await FlickrApi().fetchImages(search: search, page: page);
    } catch (e) {
      return 1;
    }
  }
}
