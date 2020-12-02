import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_bloc.dart';
import 'package:test_app/presentation/bloc/flickr_event.dart';
import 'package:test_app/presentation/bloc/flickr_state.dart';

class FlickrPage extends StatefulWidget {
  @override
  _FlickrPageState createState() => _FlickrPageState();
}

class _FlickrPageState extends State<FlickrPage> {
  var flickrBlocSink;
  bool isActiveSearch = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlickrBloc(FlickrLoaded()),
      child: BlocBuilder<FlickrBloc, FlickrState>(
        builder: (context, state) {
          flickrBlocSink = BlocProvider.of<FlickrBloc>(context);
          if (state is FlickrLoaded) {
            // flickrBlocSink.add(
            //   FetchFlickr(),
            // );
            return Scaffold(
              backgroundColor: const Color.fromRGBO(181, 201, 253, 1),
              appBar: isActiveSearch
                  ? AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: const Color(0xFF6202EE),
                      title: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 14),
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
                                isActiveSearch = false;
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
                                isActiveSearch = true;
                              });
                            }),
                      ],
                    ),
              body: GridView.count(
                crossAxisCount: 2,
                children: [
                  for (int i = 1; i < 9; i++)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/200?image=$i',
                        placeholder: (context, url) {
                          return Icon(
                            Icons.panorama,
                            size: 50,
                            color: Colors.grey[700],
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
