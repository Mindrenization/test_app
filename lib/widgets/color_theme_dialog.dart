import 'package:flutter/material.dart';

enum ColorThemes { red, orange, yellow, green, blue, purple }

class ColorThemeDialog extends StatefulWidget {
  static Color currentColor;
  final VoidCallback onChange;
  ColorThemeDialog(this.onChange);

  @override
  _ColorThemeDialogState createState() => _ColorThemeDialogState();
}

class _ColorThemeDialogState extends State<ColorThemeDialog> {
  static ColorThemes color = ColorThemes.purple;
  void onTap(value) {
    setState(() {
      color = value;
    });
    switch (color) {
      case ColorThemes.red:
        {
          ColorThemeDialog.currentColor = Colors.red;
        }
        break;
      case ColorThemes.orange:
        {
          ColorThemeDialog.currentColor = Colors.orange;
        }
        break;
      case ColorThemes.yellow:
        {
          ColorThemeDialog.currentColor = Colors.yellow;
        }
        break;
      case ColorThemes.green:
        {
          ColorThemeDialog.currentColor = Colors.green;
        }
        break;
      case ColorThemes.blue:
        {
          ColorThemeDialog.currentColor = Colors.blue;
        }
        break;
      case ColorThemes.purple:
        {
          ColorThemeDialog.currentColor = Colors.purple;
        }
        break;
    }
  }

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
                  activeColor: Colors.red,
                  value: ColorThemes.red,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
                  },
                ),
                Radio(
                  activeColor: Colors.orange,
                  value: ColorThemes.orange,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
                  },
                ),
                Radio(
                  activeColor: Colors.yellow,
                  value: ColorThemes.yellow,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
                  },
                ),
                Radio(
                  activeColor: Colors.green,
                  value: ColorThemes.green,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
                  },
                ),
                Radio(
                  activeColor: Colors.blue,
                  value: ColorThemes.blue,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
                  },
                ),
                Radio(
                  activeColor: Colors.purple,
                  value: ColorThemes.purple,
                  groupValue: color,
                  onChanged: (ColorThemes value) {
                    onTap(value);
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
