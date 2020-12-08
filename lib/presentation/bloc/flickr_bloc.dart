import 'package:bloc/bloc.dart';
import 'package:test_app/data/network/flickr_api_wrapper.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc(FlickrState initialState) : super(initialState);

  @override
  Stream<FlickrState> mapEventToState(FlickrEvent event) async* {
    if (event is FetchFlickr) {
      List<String> _imageList = event.imageList;
      var response;
      if (event.search == null)
        response = await FlickrApiWrapper().fetchImages(page: event.page);
      else
        response = await FlickrApiWrapper()
            .fetchImages(search: event.search, page: event.page);
      if (response == 1) {
        yield FlickrError();
      } else {
        _imageList.addAll(response);
        yield FlickrLoaded(imageList: _imageList);
      }
    }
    if (event is SearchFlickr) {
      yield FlickrLoading();
      List<String> _imageList =
          await FlickrApiWrapper().fetchImages(search: event.search);
      yield FlickrLoaded(imageList: _imageList);
    }
  }
}
