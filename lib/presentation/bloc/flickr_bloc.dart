import 'package:bloc/bloc.dart';
import 'package:test_app/data/models/flickr_response.dart';
import 'package:test_app/data/network/flickr_api_wrapper.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc() : super(FlickrLoading());
  List<String> _imageList = [];
  String _search;
  int _page = 0;

  @override
  Stream<FlickrState> mapEventToState(FlickrEvent event) async* {
    if (event is FetchFlickr) {
      yield* _mapFetchFlickrEventToState(event);
    }
    if (event is SearchFlickr) {
      yield* _mapSearchFlickrEventToState(event);
    }
  }

  Stream<FlickrState> _mapFetchFlickrEventToState(FetchFlickr event) async* {
    FlickrResponse _response;
    if (_search == null) {
      _response = await FlickrApiWrapper().fetchImages(page: ++_page);
    } else {
      _response = await FlickrApiWrapper().fetchImages(search: _search, page: ++_page);
    }
    if (_response.imageList != null) {
      _imageList.addAll(_response.imageList);
    }
    _response.imageList = _imageList;
    yield FlickrLoaded(_response);
  }

  Stream<FlickrState> _mapSearchFlickrEventToState(SearchFlickr event) async* {
    yield FlickrLoading();
    _page = 0;
    _search = event.search;
    FlickrResponse _response = await FlickrApiWrapper().fetchImages(search: event.search, page: ++_page);
    if (_response.imageList == null) {
      _response.imageList = [];
    } else {
      _imageList = _response.imageList;
    }
    if (_imageList.isEmpty && _response.error == null) {
      yield EmptySearch();
    } else {
      yield FlickrLoaded(_response);
    }
  }
}
