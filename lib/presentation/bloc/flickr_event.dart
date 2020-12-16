abstract class FlickrEvent {
  const FlickrEvent();
}

class FetchFlickr extends FlickrEvent {
  final String search;
  const FetchFlickr({this.search});
}

class SearchFlickr extends FlickrEvent {
  final String search;
  const SearchFlickr(this.search);
}
