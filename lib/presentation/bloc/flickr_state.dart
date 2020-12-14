import 'package:test_app/data/models/flickr_response.dart';

abstract class FlickrState {
  const FlickrState();
}

class FlickrLoading extends FlickrState {}

class FlickrLoaded extends FlickrState {
  final FlickrResponse response;
  FlickrLoaded(this.response);
}

class EmptySearch extends FlickrState {}
