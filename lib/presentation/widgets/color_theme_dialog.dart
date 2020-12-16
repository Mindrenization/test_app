import 'package:flutter/material.dart';
import 'package:test_app/presentation/constants/color_themes.dart';

// Модальное окно для выбора цветовой темы ветки
class ColorThemeDialog extends StatefulWidget {
  final Color currentMainColor;
  final Function onChange;
  ColorThemeDialog({
    this.currentMainColor,
    this.onChange,
  });

  @override
  _ColorThemeDialogState createState() => _ColorThemeDialogState();
}

class _ColorThemeDialogState extends State<ColorThemeDialog> {
  Color _currentMainColor;

  @override
  void initState() {
    super.initState();
    _currentMainColor = widget.currentMainColor;
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
                for (int i = 0; i < ColorThemes.colorThemes.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: _radioTheme(ColorThemes.colorThemes[i].mainColor, i),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _radioTheme(Color color, int index) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Radio(
        activeColor: Colors.black,
        value: color,
        groupValue: _currentMainColor,
        onChanged: (value) {
          _onTap(index);
        },
      ),
    );
  }

  void _onTap(int index) {
    setState(
      () {
        _currentMainColor = ColorThemes.colorThemes[index].mainColor;
      },
    );
    widget.onChange(index);
  }
}
