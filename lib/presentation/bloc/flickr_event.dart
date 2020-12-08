abstract class FlickrEvent {
  const FlickrEvent();
}

class FetchFlickr extends FlickrEvent {
  final List<String> imageList;
  final int page;
  final String search;
  const FetchFlickr({this.imageList, this.page, this.search});
}

class SearchFlickr extends FlickrEvent {
  final String search;
  const SearchFlickr({this.search});
}
