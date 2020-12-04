import 'package:bloc/bloc.dart';
import 'package:test_app/data/network/flickr_api.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc(FlickrState initialState) : super(initialState);

  @override
  Stream<FlickrState> mapEventToState(FlickrEvent event) async* {
    if (event is FetchFlickr) {
      List<String> imageList = event.imageList;
      try {
        imageList.addAll(await FlickrApi().fetchImages(page: event.page));
      } catch (e) {
        yield FlickrError();
      }
      yield FlickrLoaded(imageList: imageList);
    }
    if (event is SearchFlickr) {
      List<String> imageList =
          await FlickrApi().fetchImages(search: event.search);
      yield FlickrLoaded(imageList: imageList);
    }
  }
}
