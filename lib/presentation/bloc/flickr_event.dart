abstract class FlickrEvent {
  const FlickrEvent();
}

class FetchFlickr extends FlickrEvent {
  final List<String> imageList;
  final int page;
  const FetchFlickr({this.imageList, this.page});
}

class SearchFlickr extends FlickrEvent {
  final String search;
  const SearchFlickr({this.search});
}
