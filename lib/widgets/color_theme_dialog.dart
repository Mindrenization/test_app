import 'package:flutter/material.dart';

// Модал выбора цветовой темы
class ColorThemeDialog extends StatefulWidget {
  static Color mainColor = const Color(0xFF6202EE);
  static Color backgroundColor = const Color.fromRGBO(181, 201, 253, 1);
  final VoidCallback onChange;
  ColorThemeDialog({this.onChange});

  @override
  _ColorThemeDialogState createState() => _ColorThemeDialogState();
}

class _ColorThemeDialogState extends State<ColorThemeDialog> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _radioTheme(Colors.red),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.orange),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.yellow),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.green),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.blue),
                Container(
                  width: 10,
                ),
                _radioTheme(const Color(0xFF6202EE)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _radioTheme(Color color) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Radio(
        activeColor: Colors.black,
        value: color,
        groupValue: ColorThemeDialog.mainColor,
        onChanged: (value) {
          _onTap(value);
        },
      ),
    );
  }

  void _onTap(value) {
    setState(() {
      ColorThemeDialog.mainColor = value;
      if (value == Colors.red) {
        ColorThemeDialog.backgroundColor = Colors.red[100];
      } else if (value == Colors.orange) {
        ColorThemeDialog.backgroundColor = Colors.orange[100];
      } else if (value == Colors.yellow) {
        ColorThemeDialog.backgroundColor = Colors.yellow[100];
      } else if (value == Colors.green) {
        ColorThemeDialog.backgroundColor = Colors.green[100];
      } else if (value == Colors.blue) {
        ColorThemeDialog.backgroundColor = Colors.blue[100];
      } else if (value == const Color(0xFF6202EE)) {
        ColorThemeDialog.backgroundColor = Color.fromRGBO(181, 201, 253, 1);
      }
    });
    widget.onChange();
  }
}
