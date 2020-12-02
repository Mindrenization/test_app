abstract class FlickrState {
  const FlickrState();
}

class FlickrEmpty extends FlickrState {}

class FlickrLoading extends FlickrState {}

class FlickrLoaded extends FlickrState {}

class FlickrError extends FlickrState {}
