import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

// Страница работы с flickr
class FlickrPage extends StatefulWidget {
  @override
  _FlickrPageState createState() => _FlickrPageState();
}

class _FlickrPageState extends State<FlickrPage> {
  final TextEditingController _searchController = TextEditingController();
  FlickrBloc flickrBlocSink;
  bool _isActiveSearch = false;
  ScrollController _scrollController;
  List<String> _imageList = [];
  String _search;
  int _page = 1;
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      flickrBlocSink.add(
        FetchFlickr(imageList: _imageList, page: ++_page),
      );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(181, 201, 253, 1),
      appBar: _isActiveSearch
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF6202EE),
              title: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 14),
                onSubmitted: (String _search) {
                  if (_search != '') {
                    _page = 1;
                    flickrBlocSink.add(
                      SearchFlickr(search: _search),
                    );
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Waterfall',
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      FocusScope.of(context).canRequestFocus = false;
                      setState(() {
                        _isActiveSearch = false;
                      });
                      Future.delayed(Duration(milliseconds: 1), () {
                        FocusScope.of(context).canRequestFocus = true;
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.text = '';
                    },
                  ),
                ),
              ),
            )
          : AppBar(
              backgroundColor: const Color(0xFF6202EE),
              title: Text(
                'Flickr',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isActiveSearch = true;
                      });
                    }),
              ],
            ),
      body: BlocProvider(
        create: (context) => FlickrBloc(FlickrEmpty()),
        child: BlocBuilder<FlickrBloc, FlickrState>(
          builder: (context, state) {
            flickrBlocSink = BlocProvider.of<FlickrBloc>(context);
            if (state is FlickrEmpty) {
              flickrBlocSink.add(
                FetchFlickr(imageList: _imageList, page: _page),
              );
            }
            if (state is FlickrLoaded) {
              _search = state.search;
              _imageList = state.imageList;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (c, i) => Padding(
                        padding: EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            return Icon(
                              Icons.error,
                              size: 100,
                              color: Colors.grey[700],
                            );
                          },
                          imageUrl: state.imageList[i],
                          fit: BoxFit.fill,
                          placeholder: (context, url) {
                            return Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey[700],
                            );
                          },
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
            if (state is FlickrError) {
              return Text('Что-то пошло не так');
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
