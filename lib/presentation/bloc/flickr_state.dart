abstract class FlickrState {
  const FlickrState();
}

class FlickrEmpty extends FlickrState {}

class FlickrLoading extends FlickrState {}

class FlickrLoaded extends FlickrState {
  final List<String> imageList;

  FlickrLoaded(this.imageList);
}

class FlickrError extends FlickrState {}
