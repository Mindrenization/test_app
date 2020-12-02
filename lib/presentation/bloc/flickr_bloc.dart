import 'package:bloc/bloc.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc(FlickrState initialState) : super(initialState);

  @override
  Stream<FlickrState> mapEventToState(FlickrEvent event) async* {
    if (event is FetchFlickr) {
      yield FlickrLoaded();
    }
  }
}
