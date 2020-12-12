abstract class FlickrState {
  const FlickrState();
}

class FlickrEmpty extends FlickrState {}

class FlickrLoading extends FlickrState {}

class FlickrLoaded extends FlickrState {
  final String search;
  final List<String> imageList;
  FlickrLoaded({this.imageList, this.search});
}

class FlickrError extends FlickrState {}
