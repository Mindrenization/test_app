import 'package:flutter/material.dart';

class ColorThemeDialog extends StatefulWidget {
  static Color currentColor = Color(0xFF6202EE);
  final VoidCallback onChange;
  ColorThemeDialog(this.onChange);

  @override
  _ColorThemeDialogState createState() => _ColorThemeDialogState();
}

class _ColorThemeDialogState extends State<ColorThemeDialog> {
  void onTap(value) {
    setState(() {
      ColorThemeDialog.currentColor = value;
    });
  }

  Widget radioTheme(Color color) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Radio(
        activeColor: Colors.black,
        value: color,
        groupValue: ColorThemeDialog.currentColor,
        onChanged: (value) {
          onTap(value);
        },
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                radioTheme(Colors.red),
                Container(
                  width: 10,
                ),
                radioTheme(Colors.orange),
                Container(
                  width: 10,
                ),
                radioTheme(Colors.yellow),
                Container(
                  width: 10,
                ),
                radioTheme(Colors.green),
                Container(
                  width: 10,
                ),
                radioTheme(Colors.blue),
                Container(
                  width: 10,
                ),
                radioTheme(Color(0xFF6202EE)),
                IconButton(onPressed: widget.onChange, icon: Icon(Icons.check))
              ],
            )
          ],
        ),
      ),
    );
  }
}
