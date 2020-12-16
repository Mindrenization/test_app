import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/data/models/branch_theme.dart';
import 'package:test_app/presentation/bloc/flickr_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';
import 'package:test_app/presentation/widgets/flickr_bottom.dart';
import 'package:test_app/presentation/widgets/save_image_dialog.dart';
import 'package:test_app/presentation/widgets/search_appbar.dart';

// Страница работы с flickr
class FlickrPage extends StatefulWidget {
  final String branchId;
  final String taskId;
  final BranchTheme branchTheme;
  final Function onSave;
  FlickrPage(this.branchId, this.taskId, this.branchTheme, {this.onSave});
  @override
  _FlickrPageState createState() => _FlickrPageState();
}

class _FlickrPageState extends State<FlickrPage> {
  FlickrBloc _flickrBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.branchTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(0, 55),
        child: SearchAppBar(
          color: widget.branchTheme.mainColor,
          onSearch: (_value) {
            _flickrBloc.add(
              SearchFlickr(_value),
            );
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => FlickrBloc(),
        child: BlocBuilder<FlickrBloc, FlickrState>(
          builder: (context, state) {
            _flickrBloc = BlocProvider.of<FlickrBloc>(context);
            if (state is FlickrLoading) {
              _flickrBloc.add(
                FetchFlickr(),
              );
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is EmptySearch) {
              return Center(
                child: Text(
                  'По данному запросу\nкартинок не найдено',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),
              );
            }
            if (state is FlickrLoaded) {
              if (state.response.error == null) {
                _scrollController.addListener(_scrollListener);
              } else {
                _scrollController.removeListener(_scrollListener);
              }
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SaveImageDialog(
                                  state.response.imageList[i],
                                  onSave: widget.onSave,
                                );
                              },
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: state.response.imageList[i],
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
                      childCount: state.response.imageList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: FlickrBottom(
                          state.response.error,
                          widget.branchTheme.mainColor,
                          onTap: () => _flickrBloc.add(
                            FetchFlickr(),
                          ),
                        ),
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

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _flickrBloc.add(FetchFlickr());
    }
  }
}
