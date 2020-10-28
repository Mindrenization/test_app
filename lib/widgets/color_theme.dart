import 'package:flutter/material.dart';

enum ColorTheme { red, orange, yellow, green, blue, purple }

class ColorsTheme extends StatefulWidget {
  @override
  _ColorsThemeState createState() => _ColorsThemeState();
}

class _ColorsThemeState extends State<ColorsTheme> {
  static ColorTheme _color = ColorTheme.purple;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
            ),
            Text(
              'Выбор темы',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 10,
            ),
            // Row(
            //   children: [
            //     Container(
            //       decoration: BoxDecoration(
            //           color: const Color(0xFF6202EE),
            //           borderRadius: BorderRadius.circular(20)),
            //       height: 30,
            //       width: 70,
            //       child: FlatButton(
            //           child: Text('Цвет',
            //               style: TextStyle(color: Colors.grey[200])),
            //           onPressed: null),
            //     ),
            //     Container(
            //       width: 10,
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //           color: const Color(0xFF6202EE),
            //           borderRadius: BorderRadius.circular(20)),
            //       height: 30,
            //       width: 70,
            //       child: FlatButton(
            //           child: Text('Фото',
            //               style: TextStyle(color: Colors.grey[200])),
            //           onPressed: null),
            //     ),
            //   ],
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  value: ColorTheme.red,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
                Radio(
                  value: ColorTheme.orange,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
                Radio(
                  value: ColorTheme.yellow,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
                Radio(
                  value: ColorTheme.green,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
                Radio(
                  value: ColorTheme.blue,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
                Radio(
                  value: ColorTheme.purple,
                  groupValue: _color,
                  onChanged: (ColorTheme value) {
                    setState(
                      () => _color = value,
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
