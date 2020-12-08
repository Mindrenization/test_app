import 'package:bloc/bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:test_app/data/database/db_flickr.dart';
import 'package:test_app/data/models/image.dart';
import 'package:test_app/data/models/task.dart';
import 'package:test_app/data/network/flickr_api_wrapper.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';
import 'package:test_app/data/repository/repository.dart';
import 'package:uuid/uuid.dart';

class FlickrBloc extends Bloc<FlickrEvent, FlickrState> {
  FlickrBloc(FlickrState initialState) : super(initialState);
  DbFlickr _dbFlickr = DbFlickr();

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
    if (event is SaveImage) {
      var _file = await DefaultCacheManager().getSingleFile(event.imageUrl);
      Task _task = Repository.instance.getTask(event.branchId, event.taskId);
      Image _newImage = Image(Uuid().v1(), event.taskId, _file.path);
      _task.images.add(_newImage);
      _dbFlickr.createImage(_newImage);
    }
  }
}
