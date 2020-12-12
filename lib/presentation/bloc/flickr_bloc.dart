import 'package:bloc/bloc.dart';
import 'package:test_app/data/network/flickr_api_wrapper.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc(FlickrState initialState) : super(initialState);

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
    List<String> _imageList = event.imageList;
    var response;
    if (event.search == null) {
      response = await FlickrApiWrapper().fetchImages(page: event.page);
      print(response.runtimeType);
    } else {
      response = await FlickrApiWrapper().fetchImages(search: event.search, page: event.page);
    }
    if (response == 1) {
      yield FlickrError();
    } else {
      _imageList.addAll(response);
      yield FlickrLoaded(_imageList);
    }
  }

  Stream<FlickrState> _mapSearchFlickrEventToState(SearchFlickr event) async* {
    yield FlickrLoading();
    List<String> _imageList = await FlickrApiWrapper().fetchImages(search: event.search);
    yield FlickrLoaded(_imageList);
  }
}
