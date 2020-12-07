import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';
import 'package:test_app/presentation/widgets/save_image_dialog.dart';
import 'package:test_app/presentation/widgets/search_appbar.dart';
import 'package:test_app/resources/custom_color_theme.dart';

// Страница работы с flickr
class FlickrPage extends StatefulWidget {
  final String branchId;
  final String taskId;
  final CustomColorTheme customColorTheme;
  final VoidCallback onSave;
  FlickrPage(this.branchId, this.taskId, this.customColorTheme, {this.onSave});
  @override
  _FlickrPageState createState() => _FlickrPageState();
}

class _FlickrPageState extends State<FlickrPage> {
  FlickrBloc _flickrBlocSink;
  ScrollController _scrollController;
  List<String> _imageList = [];
  String _search;
  int _page = 1;
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_search == null)
        _flickrBlocSink.add(FetchFlickr(imageList: _imageList, page: ++_page));
      else
        _flickrBlocSink.add(
            FetchFlickr(imageList: _imageList, page: ++_page, search: _search));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.customColorTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(0, 55),
        child: SearchAppBar(
          customColorTheme: widget.customColorTheme,
          onSearch: (_value) {
            _page = 1;
            _search = _value;
            _flickrBlocSink.add(
              SearchFlickr(search: _value),
            );
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => FlickrBloc(FlickrEmpty()),
        child: BlocBuilder<FlickrBloc, FlickrState>(
          builder: (context, state) {
            _flickrBlocSink = BlocProvider.of<FlickrBloc>(context);
            if (state is FlickrEmpty) {
              _flickrBlocSink.add(
                FetchFlickr(imageList: _imageList, page: _page),
              );
            }
            if (state is FlickrError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.signal_wifi_off,
                      size: 70,
                    ),
                    Text(
                      'Нет соединения с интернетом',
                    ),
                    FlatButton(
                      onPressed: () {
                        _flickrBlocSink.add(
                          FetchFlickr(imageList: _imageList, page: _page),
                        );
                      },
                      child: Text(
                        'Попробовать снова',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: widget.customColorTheme.mainColor,
                    )
                  ],
                ),
              );
            }
            if (state is FlickrLoaded) {
              _imageList = state.imageList;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return SaveImageDialog(
                                  onSave: () {
                                    _flickrBlocSink.add(
                                      SaveImage(
                                        imageUrl: state.imageList[i],
                                        branchId: widget.branchId,
                                        taskId: widget.taskId,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                            widget.onSave();
                            // не всегда срабатывает своевременно
                            // узнать, как можно исправить
                          },
                          child: CachedNetworkImage(
                            imageUrl: state.imageList[i],
                            fit: BoxFit.fill,
                            errorWidget: (context, url, error) {
                              return Icon(
                                Icons.error,
                                size: 100,
                                color: Colors.grey[700],
                              );
                            },
                            placeholder: (context, url) {
                              return Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey[700],
                              );
                            },
                          ),
                        ),
                      ),
                      childCount: state.imageList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
