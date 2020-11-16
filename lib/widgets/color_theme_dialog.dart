import 'package:flutter/material.dart';
import 'package:test_app/models/branch.dart';

// Модальное окно для выбора цветовой темы
class ColorThemeDialog extends StatefulWidget {
  final Branch branch;
  final VoidCallback onChange;
  ColorThemeDialog({this.branch, this.onChange});

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
                _radioTheme(Colors.orange[700]),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.green[700]),
                Container(
                  width: 10,
                ),
                _radioTheme(Colors.cyan[800]),
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
        groupValue: widget.branch.customColorTheme.mainColor,
        onChanged: (value) {
          _onTap(value);
        },
      ),
    );
  }

  void _onTap(value) {
    setState(
      () {
        if (value == Colors.orange[700]) {
          widget.branch.customColorTheme.mainColor = value;
          widget.branch.customColorTheme.backgroundColor = Colors.orange[100];
        } else if (value == Colors.green[700]) {
          widget.branch.customColorTheme.mainColor = value;
          widget.branch.customColorTheme.backgroundColor = Colors.green[100];
        } else if (value == Colors.cyan[800]) {
          widget.branch.customColorTheme.mainColor = value;
          widget.branch.customColorTheme.backgroundColor = Colors.cyan[100];
        } else if (value == const Color(0xFF6202EE)) {
          widget.branch.customColorTheme.mainColor = value;
          widget.branch.customColorTheme.backgroundColor =
              const Color.fromRGBO(181, 201, 253, 1);
        }
      },
    );
    widget.onChange();
  }
}
