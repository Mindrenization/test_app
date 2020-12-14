import 'package:flutter/material.dart';

class FlickrBottom extends StatefulWidget {
  final String error;
  final Color color;
  final Function onTap;
  FlickrBottom(this.error, this.color, {this.onTap});
  @override
  _FlickrBottomState createState() => _FlickrBottomState();
}

class _FlickrBottomState extends State<FlickrBottom> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.error == null)
      return CircularProgressIndicator();
    else
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.error == 'network error')
              Text(
                'Нет соединения с интернетом',
              )
            else if (widget.error == 'error')
              Text(
                'Случилась непредвиденная ошибка',
              )
            else if (widget.error == 'server error')
              Text(
                'Ошибка сервера',
              ),
            _isLoading
                ? CircularProgressIndicator()
                : FlatButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      await widget.onTap();
                      setState(() => _isLoading = false);
                    },
                    child: Text(
                      'Попробовать снова',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: widget.color,
                  )
          ],
        ),
      );
  }
}
